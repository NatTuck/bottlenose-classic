#!/bin/bash
lxc launch bn-base bn-demo -e \
    -c "limits.cpu.allowance=10ms/50ms" \
    -c "limits.memory=512MB" \
    -c "limits.processes=64"
