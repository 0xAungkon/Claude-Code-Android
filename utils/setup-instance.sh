# Install services and tools
sudo apt-get install openssh-server git ttyd gh tmux curl wget zstd -y

# Configure SSH to listen on port 8022 and restart the service on login
sudo sed -i 's/^#\?Port 22/Port 8022/' /etc/ssh/sshd_config

# Install Ollama and UV
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sudo sh

command -v ollama >/dev/null 2>&1 || curl -fsSL https://ollama.com/install.sh | sudo sh

command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

# Copy service files and make them executable
sudo cp -f /home/ubuntu/.oh-my-termux/services/* /etc/init.d/
sudo chmod +x /etc/init.d/*

# Enable services to start on boot
if ! grep -qxF "source ~/.oh-my-termux/.extra_bashrc" ~/.bashrc; then
    echo 'source ~/.oh-my-termux/.extra_bashrc' >> ~/.bashrc
fi