!/bin/bash
# Install Ubuntu

cat << "EOF"
      ____ _                 _        ___           _        _ _           
     / ___| | __ _ _   _  __| | ___  |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
    | |   | |/ _` | | | |/ _` |/ _ \  | || '_ \/ __| __/ _` | | |/ _ \ '__|
    | |___| | (_| | |_| | (_| |  __/  | || | | \__ \ || (_| | | |  __/ |   
     \____|_|\__,_|\__,_|\__,_|\___| |___|_| |_|___/\__\__,_|_|_|\___|_|   
                                                                            
    Version 1.0.8
    Install Claude on Android
    Make your Development Handy
    Developed by 0xAungkon


EOF



echo "1. Updating Termux and installing dependencies..."
command -v proot-distro >/dev/null 2>&1 || { 
    echo "1. Updating Termux and installing dependencies..."
    pkg update && pkg upgrade -y
    pkg install proot-distro curl tmux -y
}

proot-distro list | grep -q "^ubuntu" || proot-distro install ubuntu

# Configure Ubuntu
if ! grep -qxF 'alias ubuntu_root="proot-distro login ubuntu"' ~/.bashrc; then
    echo 'alias ubuntu_root="proot-distro login ubuntu"' >> ~/.bashrc
fi

if ! grep -qxF 'alias ubuntu="proot-distro login ubuntu -- bash -lc \"su - ubuntu -\""' ~/.bashrc; then
    echo 'alias ubuntu="proot-distro login ubuntu -- bash -lc \"su - ubuntu -\""' >> ~/.bashrc
fi

echo "2. Setting up Ubuntu instance..."
# Create a new user and add to sudo group
proot-distro login ubuntu -- bash -lc '
apt update && apt upgrade -y &&
apt install -y sudo git &&
id -u ubuntu >/dev/null 2>&1 || {
    adduser --disabled-password --gecos "" ubuntu &&
    usermod -aG sudo ubuntu &&
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu &&
    chmod 440 /etc/sudoers.d/ubuntu
}
'

echo "Set a password for the 'ubuntu' user:"
read -s -p "Enter password: " PW && echo && proot-distro login ubuntu -- bash -lc "echo \"ubuntu:$PW\" | chpasswd"

echo "3. Installing services and tools inside Ubuntu..."

# Set up Ollama and other services
proot-distro login ubuntu --user ubuntu -- bash -lc '
if [ -d /home/ubuntu/.oh-my-termux/.git ]; then
    git -C /home/ubuntu/.oh-my-termux pull
else
    git clone https://github.com/0xAungkon/Full-Claude-Environment-Termux.git /home/ubuntu/.oh-my-termux
fi
'

proot-distro login ubuntu --user ubuntu -- bash -lc "bash /home/ubuntu/.oh-my-termux/utils/setup-instance.sh"

proot-distro login ubuntu --user ubuntu 
