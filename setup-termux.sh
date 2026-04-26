# Install Ubuntu
pkg update && pkg upgrade -y
pkg install proot-distro curl tmux -y
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

read -s -p "Enter password: " PW && echo && proot-distro login ubuntu -- bash -lc "echo \"ubuntu:$PW\" | chpasswd"

proot-distro login ubuntu
