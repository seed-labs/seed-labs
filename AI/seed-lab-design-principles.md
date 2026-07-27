# SEED Lab Design Principles for AI-Assisted Lab Development

This guide summarizes design principles used by existing SEED labs. Use it to
guide AI systems when developing new lab descriptions on new ideas, attacks, and
defense mechanisms.

## Core Philosophy

SEED labs are based on learning by doing. A good lab gives students a realistic
but controlled vulnerable system, asks them to perform concrete attacks or
defenses, and requires them to explain what they observed.

Students should work with real tools whenever possible, such as Docker,
terminals, browsers, OpenSSL, MySQL, curl, netcat, compilers, packet tools,
source code, configuration files, and logs. The goal is operational intuition,
not just conceptual vocabulary.

## Standard Lab Structure

Follow the common SEED lab structure:

1. Overview
2. Readings
3. Lab Environment
4. Theories
5. Lab Tasks
6. Guidelines
7. Submission

The overview should explain the security concept, why it matters, what students
will do, and the learning outcomes. It should also list the main topics covered
by the lab.

The readings section should point to relevant book chapters, papers, videos, or
official documentation.

The lab environment section should describe all VM, container, topology,
hostname, IP address, credential, folder, and setup assumptions.

The theories section should explain the theories that we would like students 
to master after doing the lab tasks. The tasks should connect to the theories.

The lab tasks should be numbered and should move from familiarization to attack
or experiment, then to variants, deeper reasoning, and defenses.

The guidelines section should contain longer hints, debugging methods, command
explanations, or background material that would interrupt the task flow.

The submission section should require screenshots, observations, explanations,
and important code snippets with explanation.

## Task Design

Start with a familiarization task. Before asking students to exploit or defend a
system, let them inspect the environment, try basic commands, read relevant code,
or understand the data model.

Escalate tasks in layers:

1. Basic concept demonstration
2. First successful attack or experiment
3. More realistic variant
4. Edge case or limitation
5. Defense or countermeasure
6. Explanation of why the defense works or fails

Each task should ask students to both do and explain. Good task prompts include:

- Demonstrate that the attack works.
- Provide screenshots.
- Describe what you observed.
- Explain why this happened.
- Evaluate whether the countermeasure works.

## Attack and Defense Balance

Do not stop at exploitation. Mature SEED labs usually include both offensive and
defensive learning.

For each new lab, consider including:

- The root cause of the vulnerability or weakness
- The practical impact
- A working attack or misuse scenario
- A mitigation or countermeasure
- Limitations of the mitigation
- A reflection question about why the mechanism works

## Controlled Realism

Use realistic tools in a bounded, reproducible environment. The lab should feel
close to a real system, but it should avoid uncontrolled real-world targeting or
unsafe behavior outside the lab environment.

Good patterns include:

- Docker containers for reproducible vulnerable services
- Private networks and stable IP addresses such as 10.9.0.x
- Hostname mappings through /etc/hosts
- Real software such as Apache, PHP, MySQL, OpenSSL, gcc, and Linux utilities
- Simulated attack conditions when a real attack would be unsafe or unreliable

Prefer "real tools in a sandbox" over toy examples.

## Scaffolding

Provide enough support for students to start, but do not give away the final
answer.

Useful scaffolding patterns include:

- Vulnerable source code snippets
- Incomplete exploit or defense skeletons
- Command templates
- Example inputs and expected benign outputs
- Hints about where to inspect logs or source code
- Clear markers for values students must determine themselves

Leave key reasoning steps, payload details, defense implementation details, or
explanations for students to discover.

## Environment Design

Use Docker when possible. Put lab-specific setup files under `Labsetup`, and
provide `Labsetup-arm` when architecture differences matter.

Environment documentation should include:

- `docker-compose.yml`
- Dockerfiles for custom images
- Stable container IP addresses
- Hostnames and `/etc/hosts` mappings
- Where files live on the host
- Where files live inside containers
- Build, start, stop, rebuild, and shell-access commands
- Any required VM-level configuration

Students should be able to destroy and recreate the lab environment without
losing the core lab design.

## Platform and Architecture Notes

Explicitly document differences between Ubuntu versions, x86, x86-64, and ARM
when they affect the lab.

If Apple Silicon or ARM behavior differs, explain the difference and either
provide an ARM-specific setup or mark the affected tasks as optional or
architecture-specific.

## Instructor Customization

Include knobs that instructors can change so old solutions do not directly
apply.

Examples include:

- Per-student domain names
- Randomized or instructor-selected constants
- Different datasets
- Different ports, hostnames, or IP mappings
- Parameterized vulnerable program values
- Optional advanced tasks
- Architecture-specific variants

Explain which values instructors can safely change and what ranges are
reasonable.

## Writing Style

Use clear, direct, student-facing language. Explain only enough theory to make
the task meaningful, then move quickly to concrete actions.

Common SEED-style phrases include:

- The objective of this task is...
- Your task is to...
- Please demonstrate...
- Please describe and explain your observations.
- To help you get started...
- It should be noted that...

Keep explanations close to the task where they are needed. Use concrete
commands, paths, hostnames, IP addresses, file names, and expected observations.

## Submission Expectations

Require a detailed lab report. Students should submit:

- Screenshots showing important results
- A description of what they did
- Observations from each major experiment
- Explanations for interesting or surprising behavior
- Important code snippets with explanations
- Evidence that attacks or defenses worked

Code without explanation should not be considered sufficient.

## Reusable AI Prompt

Use the following prompt as a starting point when asking AI to draft a new
SEED-style lab:

```text
Create a SEED-style cybersecurity lab description.

Follow these principles:
- Use the SEED structure: Overview, Readings, Lab Environment, Lab Tasks,
  Guidelines, Submission.
- Make the lab hands-on and observation-driven.
- Use realistic tools in a reproducible Docker-based environment.
- Start with a familiarization task, then escalate to attack or experiment
  tasks, then defense or countermeasure tasks.
- Provide enough scaffolding to begin, but leave key reasoning and exploit or
  defense details for students.
- Include screenshots, observations, and explanations as submission
  requirements.
- Include instructor customization points.
- Use clear student-facing language and concrete commands, paths, hostnames,
  IPs, and files.
- Prefer bounded simulation of dangerous behavior over uncontrolled real-world
  targeting.
- Include ARM, x86, or platform notes if relevant.
```

In short, a SEED lab should be reproducible, realistic, scaffolded, balanced
between attack and defense, observation-driven, and easy for instructors to
customize.
