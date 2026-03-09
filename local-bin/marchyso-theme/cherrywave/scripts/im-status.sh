#!/bin/bash

status=$(fcitx5-remote)

if [ "$status" = "2" ]; then
    echo "VI"
else
    echo "EN"
fi
