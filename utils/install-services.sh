# !/bin/bash

apt update && apt upgrade -y

sudo apt install openssh-server git ttyd gh tmux

sudo sed -i 's/^#\?Port 22/Port 8022/' /etc/ssh/sshd_config 

curl -LsSf https://astral.sh/uv/install.sh | sh

curl -fsSL https://claude.ai/install.sh | bash

curl -fsSL https://ollama.com/install.sh | sh

cat <<'EOF' >> "$HOME/.bashrc"
# Ollama + Claude-compatible environment
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_API_KEY=""
export ANTHROPIC_BASE_URL=http://localhost:11434
export ANTHROPIC_DEFAULT_SONNET_MODEL=kimi-k2.6:cloud
export ANTHROPIC_DEFAULT_HAIKU_MODEL=minimax-m2.7:cloud
export ANTHROPIC_DEFAULT_OPUS_MODEL=kimi-k2.5:cloud
EOF



git config --global init.defaultBranch main
git config --global user.email "claude@gmail.com"
git config --global user.name "claude"