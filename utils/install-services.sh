
apt update && apt upgrade -y

sudo apt install openssh-server git ttyd gh tmux

sudo sed -i 's/^#\?Port 22/Port 8022/' /etc/ssh/sshd_config 

curl -fsSL https://claude.ai/install.sh | bash

curl -LsSf https://astral.sh/uv/install.sh | sh

curl -fsSL https://ollama.com/install.sh | sh

