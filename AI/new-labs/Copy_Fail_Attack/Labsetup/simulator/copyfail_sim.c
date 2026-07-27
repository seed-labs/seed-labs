#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define STATE_FILE ".sim_state.bin"
#define TEMPLATE_FILE "files/passwd.template"
#define MAGIC 0x5345454443464149ULL
#define KBUF_SIZE 64
#define CACHE_SIZE 512

struct sim_state {
    uint64_t magic;
    unsigned char kbuf[KBUF_SIZE];
    unsigned char cache[CACHE_SIZE];
    size_t cache_len;
};

static void die(const char *msg)
{
    perror(msg);
    exit(1);
}

static void init_state(struct sim_state *st)
{
    FILE *fp;

    memset(st, 0, sizeof(*st));
    st->magic = MAGIC;
    memset(st->kbuf, '.', sizeof(st->kbuf));

    fp = fopen(TEMPLATE_FILE, "rb");
    if (fp == NULL) {
        die("open template");
    }

    st->cache_len = fread(st->cache, 1, sizeof(st->cache) - 1, fp);
    if (ferror(fp)) {
        fclose(fp);
        die("read template");
    }
    fclose(fp);
}

static void load_state(struct sim_state *st)
{
    FILE *fp = fopen(STATE_FILE, "rb");

    if (fp == NULL) {
        init_state(st);
        return;
    }

    if (fread(st, sizeof(*st), 1, fp) != 1 || st->magic != MAGIC) {
        fclose(fp);
        init_state(st);
        return;
    }
    fclose(fp);
}

static void save_state(const struct sim_state *st)
{
    FILE *fp = fopen(STATE_FILE, "wb");
    if (fp == NULL) {
        die("save state");
    }
    if (fwrite(st, sizeof(*st), 1, fp) != 1) {
        fclose(fp);
        die("write state");
    }
    fclose(fp);
}

static void print_bytes(const char *label, const unsigned char *buf, size_t len)
{
    size_t i;

    printf("%s", label);
    for (i = 0; i < len; i++) {
        unsigned char c = buf[i];
        if (c >= 32 && c <= 126) {
            putchar(c);
        } else {
            putchar('.');
        }
    }
    putchar('\n');
}

static size_t simulated_copy_from_user(unsigned char *dst, const char *src,
                                       size_t len, int fail_after)
{
    size_t copied;

    if (len > KBUF_SIZE) {
        len = KBUF_SIZE;
    }

    if (fail_after >= 0 && (size_t)fail_after < len) {
        copied = (size_t)fail_after;
    } else {
        copied = len;
    }

    memcpy(dst, src, copied);
    return len - copied;
}

static void vulnerable_cache_write(struct sim_state *st, size_t offset, size_t len)
{
    if (offset >= st->cache_len) {
        printf("[!] Offset is outside the simulated page cache.\n");
        return;
    }
    if (len > KBUF_SIZE) {
        len = KBUF_SIZE;
    }
    if (offset + len > st->cache_len) {
        len = st->cache_len - offset;
    }
    memcpy(st->cache + offset, st->kbuf, len);
}

static void show_cache(const struct sim_state *st)
{
    printf("----- simulated page cache -----\n");
    fwrite(st->cache, 1, st->cache_len, stdout);
    if (st->cache_len == 0 || st->cache[st->cache_len - 1] != '\n') {
        putchar('\n');
    }
    printf("--------------------------------\n");
}

static void check_login(const struct sim_state *st, const char *user)
{
    char needle[128];
    char *copy;
    char *line;
    char *saveptr = NULL;

    snprintf(needle, sizeof(needle), "%s:enabled:", user);
    copy = calloc(st->cache_len + 1, 1);
    if (copy == NULL) {
        die("calloc");
    }
    memcpy(copy, st->cache, st->cache_len);

    line = strtok_r(copy, "\n", &saveptr);
    while (line != NULL) {
        if (strstr(line, needle) == line) {
            printf("[+] Login check accepted user '%s'.\n", user);
            free(copy);
            return;
        }
        line = strtok_r(NULL, "\n", &saveptr);
    }

    printf("[-] Login check rejected user '%s'.\n", user);
    free(copy);
}

static void usage(const char *prog)
{
    printf("Usage:\n");
    printf("  %s --help\n", prog);
    printf("  %s --reset\n", prog);
    printf("  %s --show-cache\n", prog);
    printf("  %s --check-login USER\n", prog);
    printf("  %s --mode normal|fail --input STR [--fail-after N] [--write-cache --offset N --len N]\n", prog);
}

int main(int argc, char **argv)
{
    struct sim_state st;
    const char *mode = NULL;
    const char *input = NULL;
    const char *login_user = NULL;
    int fail_after = -1;
    int do_reset = 0;
    int do_show_cache = 0;
    int do_write_cache = 0;
    size_t offset = 0;
    size_t write_len = 0;
    size_t ret;
    int i;

    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--reset") == 0) {
            do_reset = 1;
        } else if (strcmp(argv[i], "--show-cache") == 0) {
            do_show_cache = 1;
        } else if (strcmp(argv[i], "--check-login") == 0 && i + 1 < argc) {
            login_user = argv[++i];
        } else if (strcmp(argv[i], "--mode") == 0 && i + 1 < argc) {
            mode = argv[++i];
        } else if (strcmp(argv[i], "--input") == 0 && i + 1 < argc) {
            input = argv[++i];
        } else if (strcmp(argv[i], "--fail-after") == 0 && i + 1 < argc) {
            fail_after = atoi(argv[++i]);
        } else if (strcmp(argv[i], "--write-cache") == 0) {
            do_write_cache = 1;
        } else if (strcmp(argv[i], "--offset") == 0 && i + 1 < argc) {
            offset = (size_t)strtoul(argv[++i], NULL, 0);
        } else if (strcmp(argv[i], "--len") == 0 && i + 1 < argc) {
            write_len = (size_t)strtoul(argv[++i], NULL, 0);
        } else {
            usage(argv[0]);
            return 1;
        }
    }

    if (do_reset) {
        init_state(&st);
        save_state(&st);
        printf("[+] Simulator state reset.\n");
        return 0;
    }

    load_state(&st);

    if (do_show_cache) {
        show_cache(&st);
        return 0;
    }

    if (login_user != NULL) {
        check_login(&st, login_user);
        return 0;
    }

    if (mode == NULL || input == NULL) {
        usage(argv[0]);
        return 1;
    }

    if (strcmp(mode, "normal") == 0) {
        fail_after = -1;
    } else if (strcmp(mode, "fail") != 0) {
        usage(argv[0]);
        return 1;
    }

    print_bytes("[before] kbuf: ", st.kbuf, 32);
    ret = simulated_copy_from_user(st.kbuf, input, strlen(input), fail_after);
    printf("[copy] requested=%zu not_copied=%zu\n", strlen(input), ret);
    print_bytes("[after ] kbuf: ", st.kbuf, 32);

    if (do_write_cache) {
        if (write_len == 0) {
            write_len = strlen(input);
        }
        printf("[vuln] using kbuf after copy result; cache offset=%zu len=%zu\n",
               offset, write_len);
        vulnerable_cache_write(&st, offset, write_len);
    }

    save_state(&st);
    return 0;
}
