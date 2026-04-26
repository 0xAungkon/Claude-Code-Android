# Install Ubuntu
pkg update && pkg upgrade -y
pkg install proot-distro curl -y
proot-distro install ubuntu

# Configure Ubuntu
echo 'alias ubuntu_root="proot-distro login ubuntu"' >> ~/.bashrc
echo 'alias ubuntu="proot-distro login ubuntu -- bash -lc \"su - ubuntu -\""' >> ~/.bashrc

# Create a new user and add to sudo group
proot-distro login ubuntu -- bash -lc '
apt update && apt upgrade -y &&
apt install sudo -y &&
adduser --disabled-password --gecos "" ubuntu &&
usermod -aG sudo ubuntu &&
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu &&
chmod 440 /etc/sudoers.d/ubuntu
'

# Install services and tools
proot-distro login ubuntu -- bash -lc "sudo apt install openssh-server git ttyd gh tmux"

# Configure SSH to listen on port 8022 and restart the service on login
proot-distro login ubuntu -- bash -lc "sed -i 's/^#\?Port 22/Port 8022/' /etc/ssh/sshd_config"

read -s -p "Enter password: " PW && echo && proot-distro login ubuntu -- bash -lc "echo \"ubuntu:$PW\" | chpasswd"

proot-distro login ubuntu -- bash -lc 'curl -LsSf https://astral.sh/uv/install.sh | sh'
proot-distro login ubuntu -- bash -lc 'curl -fsSL https://ollama.com/install.sh | sh'


proot-distro login ubuntu