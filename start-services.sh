if service ssh status >/dev/null 2>&1; then
    echo "SSH already running"
else
    sudo service ssh restart
fi



while true; do
    sleep 60
done