class CheckFailure(RuntimeError):
    """An observed environment violates a declared requirement."""


class Blocked(RuntimeError):
    """The selected environment cannot be tested on this machine."""
