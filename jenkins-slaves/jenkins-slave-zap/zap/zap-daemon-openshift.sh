#!/bin/bash

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

echo "zap:x:${USER_ID}:${GROUP_ID}:Zed Attack Proxy,,,:/zap:/bin/bash" >> /etc/passwd

exec $@