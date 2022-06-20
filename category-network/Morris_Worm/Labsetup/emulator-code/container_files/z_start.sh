#!/bin/bash

ls | grep -Ev '.yml$|^dummies$|^morris|^z_start' | xargs -n10 -exec docker-compose up -d
