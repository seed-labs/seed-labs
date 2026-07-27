# Copy Fail Attack Lab

This folder contains a draft SEED-style lab description for the Copy Fail
attack, associated with CVE-2026-31431.

Files:

- `Copy_Fail_Attack.tex`: lab description in LaTeX format
- `Makefile`: compiles the lab description into PDF
- `Labsetup/`: safe user-space simulator and student skeleton files
- `Instructor_Manual.md`: instructor-only solution manual; do not distribute
  to students

To build the PDF on a machine with LaTeX installed, run:

```bash
make
```

To build the simulator on a Linux machine with `gcc` installed, run:

```bash
cd Labsetup
make
```
