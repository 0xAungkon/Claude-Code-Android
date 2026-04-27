#!/bin/bash

FG=false
[[ "$1" == "--fg" ]] && FG=true

while true; do
    if service ssh status >/dev/null 2>&1; then
        echo "SSH already running"
    else
        echo "SSH not running, restarting..."
        sudo service ssh restart
    fi

    if service btop status >/dev/null 2>&1; then
        echo "Btop already running"
    else
        echo "Btop not running, restarting..."
        sudo service btop restart
    fi

    if service ollama status >/dev/null 2>&1; then
        echo "Ollama already running"
    else
        sudo service ollama restart
        echo "Ollama restarted"
    fi

    if service ttyd status >/dev/null 2>&1; then
        echo "ttyd already running"
    else
        sudo service ttyd restart
        echo "ttyd restarted"
    fi

    $FG || break
    
    sleep 60
done