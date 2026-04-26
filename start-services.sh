#!/bin/bash

FG=false
[[ "$1" == "--fg" ]] && FG=true

while true; do
    if service ssh status >/dev/null 2>&1; then
        echo "SSH already running"
    else
        sudo service ssh restart
    fi

    if service btop status >/dev/null 2>&1; then
        echo "Btop already running"
    else
        sudo service btop restart
    fi

    if service ollama status >/dev/null 2>&1; then
        echo "Ollama already running"
    else
        sudo service ollama restart
    fi

    if service ttyd status >/dev/null 2>&1; then
        echo "ttyd already running"
    else
        sudo service ttyd restart
    fi

    $FG || break
    
    sleep 3
done