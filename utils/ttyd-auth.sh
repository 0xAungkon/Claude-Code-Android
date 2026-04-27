# /home/ubuntu/.oh-my-termux/utils/ttyd-auth.sh
#!/usr/bin/env bash

USER_NAME="$(id -un)"

printf "Password: "
stty -echo
read INPUT_PASS
stty echo
printf "\n"

if ! echo "$INPUT_PASS" | su -c "exit" "$USER_NAME" >/dev/null 2>&1; then
    echo "Authentication failed"
    sleep 1
    exit 1
fi

exec "$@"