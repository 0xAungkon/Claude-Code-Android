pkg update && pkg upgrade -y
pkg install proot-distro -y
proot-distro install ubuntu
proot-distro login ubuntu

echo "proot-distro login ubuntu" > $PREFIX/bin/ubuntu
chmod +x $PREFIX/bin/ubuntu
echo 'proot-distro login ubuntu -u ubuntu; exit' >> ~/.bashrc
proot-distro login ubuntu -- bash -lc 'apt update && apt upgrade -y && apt install sudo -y && adduser --disabled-password --gecos "" ubuntu && usermod -aG sudo ubuntu'
