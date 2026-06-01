# Labsetup Helper Files

This folder contains helper files for the BGP RPKI and Route Origin Validation
lab.

- `roa-table.txt`: a small educational ROA table for selected emulator ASes
- `generate_bird_rov_filter.py`: generates a simple BIRD filter function from
  the ROA table

Run:

```bash
python3 generate_bird_rov_filter.py roa-table.txt
```

The generated filter is intentionally simple. It models Route Origin Validation
inside the emulator without requiring a full RPKI validator or RTR session.
