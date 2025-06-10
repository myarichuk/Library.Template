#!/usr/bin/env bash
set -euo pipefail

if ! command -v pre-commit &>/dev/null; then
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip git
    fi
    pip3 install --user virtualenv==20.0.33 pre-commit
fi

pre-commit install
pre-commit install --hook-type commit-msg
pre-commit run --all-files

