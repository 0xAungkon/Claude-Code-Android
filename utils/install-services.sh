
apt update && apt upgrade -y

sudo apt install openssh-server git ttyd gh tmux

sudo sed -i 's/^#\?Port 22/Port 8022/' /etc/ssh/sshd_config 

curl -fsSL https://claude.ai/install.sh | bash

curl -LsSf https://astral.sh/uv/install.sh | sh

curl -fsSL https://ollama.com/install.sh | sh

git config --global init.defaultBranch main
git config --global user.email "claude@gmail.com"
git config --global user.name "claude"