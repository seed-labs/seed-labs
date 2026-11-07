#!/usr/bin/env python3
"""Local and CI entry point; no installation or PYTHONPATH required."""
from testing.cli import main

if __name__ == "__main__":
    raise SystemExit(main())
