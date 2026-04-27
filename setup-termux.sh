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

echo "0. Setup Termux"
echo "Set Termux password:"
passwd


echo "1. Updating Termux and installing dependencies..."
command -v proot-distro >/dev/null 2>&1 || { 
    echo "1. Updating Termux and installing dependencies..."
    pkg update && pkg upgrade -y
    pkg install proot-distro curl tmux openssh -y
}

if ! grep -qxF 'sshd' ~/.bashrc; then
    echo 'sshd' >> ~/.bashrc
fi

sshd

proot-distro list | grep -q "^ubuntu" || proot-distro install ubuntu

# Configure Ubuntu
if ! grep -qxF 'alias ubuntu_root="proot-distro login ubuntu"' ~/.bashrc; then
    echo 'alias ubuntu_root="proot-distro login ubuntu"' >> ~/.bashrc
fi

if ! grep -qxF 'alias ubuntu="proot-distro login ubuntu --user ubuntu"' ~/.bashrc; then
    echo 'alias ubuntu="proot-distro login ubuntu --user ubuntu"' >> ~/.bashrc
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

if ! grep -qxF 'alias u_service' ~/.bashrc; then
    echo 'alias u_service="proot-distro login ubuntu --user ubuntu -- bash -lc '"'"'/home/ubuntu/.oh-my-termux/utils/start-services.sh --fg'"'"'"' >> ~/.bashrc
fi

grep -qF 'service-runner' ~/.bashrc || cat >> ~/.bashrc << 'EOF'
tmux has-session -t service-runner 2>/dev/null || tmux new-session -d -s service-runner 'proot-distro login ubuntu --user ubuntu -- bash -lc "bash /home/ubuntu/.oh-my-termux/utils/start-services.sh --fg"; tmux kill-session -t service-runner'
EOF


if ! grep -qF 'alias u=' ~/.bashrc; then
    echo 'alias u="proot-distro login ubuntu --user ubuntu -- bash -lc '"'"'tmux -S /tmp/tmux-main new-session -As terminal -c /home/ubuntu/home'"'"'"' >> ~/.bashrc
fi