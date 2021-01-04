#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/wait.h>
// #include <sys/types.h>

// Total number of servers
#define N 1

int socket_bind(int port)
{
    int server_fd;
    int opt = 1;
    struct sockaddr_in address;

    // Creating socket file descriptor
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)))
    {
        perror("setsockopt failed");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(port);

    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    if (listen(server_fd, 3) < 0)
    {
        perror("listen failed");
        exit(EXIT_FAILURE);
    }

    return server_fd;
}

int select_accept(int fds[], unsigned count, struct sockaddr *addr, socklen_t *addrlen, unsigned &server_idx)
{
    fd_set writefds;

    FD_ZERO(&writefds);

    int maxfd = -1;
    for (server_idx = 0; server_idx < count; server_idx++)
    {
        FD_SET(fds[server_idx], &writefds);
        if (fds[server_idx] > maxfd)
        {
            maxfd = fds[server_idx];
        }
    }

    int status = select(maxfd + 1, &writefds, nullptr, nullptr, nullptr);
    if (status < 0)
    {
        return status;
    }

    int server_fd = -1;
    for (server_idx = 0; server_idx < count; server_idx++)
    {
        if (FD_ISSET(fds[server_idx], &writefds))
        {
            server_fd = fds[server_idx];
            break;
        }
    }

    return (server_fd == -1) ? -1 : accept(server_fd, addr, addrlen);
}

int main(int argc, char const *argv[])
{
    struct
    {
        int port;
        const char *binary;
    } programs[N] = {
        // Initially, port 5000 is for the padding oracle.
	// That task is moved to another lab, so the port is no longer used.
        {.port = 3000, .binary = "known_iv"}
        //{.port = 5000, .binary = "known_iv"}
      };

    int server_fds[N] = {
        socket_bind(programs[0].port)   // for predictable_iv
        //socket_bind(programs[1].port)  // for predictable_iv
    };

    struct sockaddr_in address;
    unsigned addrlen = sizeof(address);

    for (auto prog : programs)
    {
        printf("Server listening on %d for %s\n", prog.port, prog.binary);
    }

    while (true)
    {
        while (waitpid(-1, nullptr, WNOHANG) > 0)
            ;

        unsigned server_idx;
        int socket_fd = select_accept(server_fds, N, (struct sockaddr *)&address, 
	                              (socklen_t *)&addrlen, server_idx);
        if (socket_fd < 0)
        {
            perror("accept failed");
            exit(EXIT_FAILURE);
        }

        printf("Connect to %d, launching %s\n", programs[server_idx].port, programs[server_idx].binary);

        if (fork() == 0)
        {
            int socket_fd2 = dup(socket_fd);
            dup2(socket_fd, STDIN_FILENO);
            dup2(socket_fd2, STDOUT_FILENO);

            execl(programs[server_idx].binary, programs[server_idx].binary);
        }
        else
        {
            close(socket_fd);
        }
    }

    return 0;
}
