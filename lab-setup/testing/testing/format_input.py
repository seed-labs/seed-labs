"""Interpret only the normal-input trace supplied by the Format String lab."""
import re


def buffer_trace(logs, byte_count):
    start = logs.rfind("Starting stack")
    if start < 0:
        return None
    block = logs[start:]
    if "==== Returned Properly ====" not in block:
        return None
    received = re.search(r"Input size: (\d+)", block)
    if not received or int(received[1]) != byte_count:
        raise ValueError("normal stack input byte count does not match")
    return {"received_bytes": int(received[1]), "returned_properly": True}


def normal_trace(logs, marker, byte_count):
    """Return None for incomplete logs; reject completed but incorrect traces."""
    # The server prints addresses to its console, not to the TCP client.
    position = logs.find(marker)
    if position < 0:
        return None
    start = logs.rfind("Starting format", 0, position)
    if start < 0:
        return None
    end = logs.find("Starting format", position)
    block = logs[start:end] if end >= 0 else logs[start:]
    if "Returned properly" not in block:
        return None
    before = re.search(r"The target variable's value \(before\):\s*(0x[0-9a-fA-F]+)", block)
    after = re.search(r"The target variable's value \(after\):\s*(0x[0-9a-fA-F]+)", block)
    received = re.search(r"Received (\d+) bytes\.", block)
    if not before or not after or not received:
        raise ValueError("normal-input trace is missing byte count or target values")
    if int(received[1]) != byte_count:
        raise ValueError(f"received {received[1]} bytes, expected {byte_count}")
    if int(before[1], 16) != int(after[1], 16):
        raise ValueError(f"normal input changed target: {before[1]} -> {after[1]}")
    return {"received_bytes": int(received[1]), "target_before": before[1], "target_after": after[1],
            "returned_properly": True}
