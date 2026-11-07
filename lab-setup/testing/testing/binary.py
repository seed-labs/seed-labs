"""Read ELF metadata without installing tools into the tested container."""
import struct


def elf_metadata(path):
    data = path.read_bytes()
    if len(data) < 16 or data[:4] != b"\x7fELF" or data[4] not in (1, 2) or data[5] not in (1, 2):
        raise ValueError(f"not a supported ELF file: {path}")
    bits = 32 if data[4] == 1 else 64
    endian = "<" if data[5] == 1 else ">"
    header_format = endian + ("HHIIIIIHHHHHH" if bits == 32 else "HHIQQQIHHHHHH")
    if len(data) < 16 + struct.calcsize(header_format):
        raise ValueError("truncated ELF header")
    header = struct.unpack_from(header_format, data, 16)
    machine = {3: "i386", 62: "x86_64", 183: "aarch64"}.get(header[1], str(header[1]))
    offset, entry_size, count = header[4], header[8], header[9]
    fmt = endian + ("IIIIIIII" if bits == 32 else "IIQQQQQQ")
    if not count or count == 0xffff or entry_size < struct.calcsize(fmt) or offset + entry_size * count > len(data):
        raise ValueError("missing, truncated or unsupported ELF program header table")
    types, stack = set(), None
    for i in range(count):
        fields = struct.unpack_from(fmt, data, offset + i * entry_size)
        types.add(fields[0])
        if fields[0] == 0x6474e551:  # PT_GNU_STACK
            flags = fields[6] if bits == 32 else fields[1]
            stack = bool(flags & 1)  # PF_X
    return {"elf_class": bits, "machine": machine, "static": 2 not in types and 3 not in types,
            "executable_stack": stack}
