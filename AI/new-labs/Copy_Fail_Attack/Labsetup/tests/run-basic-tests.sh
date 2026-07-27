#!/bin/bash

set -e

cd "$(dirname "$0")/.."

make
./simulator/copyfail_sim --reset
./simulator/copyfail_sim --mode normal --input hello
./simulator/copyfail_sim --mode fail --input hello --fail-after 2
./simulator/copyfail_sim --show-cache
./simulator/copyfail_sim --check-login student
