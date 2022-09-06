#!/bin/bash

# Tells xinetd to stay in the foreground rather than detaching itself, so that Docker container will stay alive.
xinetd -dontfork

