# Install services and tools
sudo apt-get install openssh-server git ttyd gh tmux -y

# Configure SSH to listen on port 8022 and restart the service on login
sudo sed -i 's/^#\?Port 22/Port 8022/' /etc/ssh/sshd_config

# Install Ollama and UV
curl -LsSf https://astral.sh/uv/install.sh | sudo sh
curl -fsSL https://ollama.com/install.sh | sudo sh
curl -fsSL https://claude.ai/install.sh | bash

# Set up Ollama and other services
git clone https://github.com/0xAungkon/Full-Claude-Environment-Termux.git /home/ubuntu/.oh-my-termux

# Copy service files and make them executable
sudo cp /home/ubuntu/.oh-my-termux/services/*  /etc/init.d/ 
sudo chmod +x /etc/init.d/*

echo 'source ~/.oh-my-termux/.extra_bashrc' >> ~/.bashrc