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

    # if service htop status >/dev/null 2>&1; then
    #     echo "Htop already running"
    # else
    #     echo "Htop not running, restarting..."
    #     /home/ubuntu/.oh-my-termux/services/htop restart
    # fi

    if service ollama status >/dev/null 2>&1; then
        echo "Ollama already running"
    else
        /home/ubuntu/.oh-my-termux/services/ollama restart
        echo "Ollama restarted"
    fi

    # if service ttyd status >/dev/null 2>&1; then
    #     echo "ttyd already running"
    # else
    #     /home/ubuntu/.oh-my-termux/services/ttyd restart
    #     echo "ttyd restarted"
    # fi
    

    $FG || break
    
    sleep 60
done