# /usr/local/bin/ttyd-auth
#!/bin/bash

USER_NAME="$(id -un)"

read -rsp "Password: " INPUT_PASS
echo

if ! echo "$INPUT_PASS" | su -c "exit" "$USER_NAME" >/dev/null 2>&1; then
    echo "Authentication failed"
    sleep 1
    exit 1
fi

exec "$@"