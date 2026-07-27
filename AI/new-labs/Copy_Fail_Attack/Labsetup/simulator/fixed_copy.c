/*
 * This file is used for Task 5. It contains sketches of three defensive
 * patterns. Students should copy the relevant ideas into copyfail_sim.c and
 * evaluate them one at a time.
 */

#include <string.h>
#include <errno.h>

/*
 * Defense 1: reject partial copies.
 */
int reject_partial_copy(size_t not_copied)
{
    if (not_copied != 0) {
        return -EFAULT;
    }
    return 0;
}

/*
 * Defense 2: clear a reusable destination buffer before copying into it.
 */
void clear_destination_buffer(unsigned char *buf, size_t len)
{
    memset(buf, 0, len);
}

/*
 * Defense 3: never pass the originally requested length to later code after
 * a failed copy. Track the actual valid length instead.
 */
size_t valid_length_after_copy(size_t requested, size_t not_copied)
{
    if (not_copied > requested) {
        return 0;
    }
    return requested - not_copied;
}
