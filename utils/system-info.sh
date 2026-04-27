#!/bin/bash

OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
KERNEL=$(uname -r)
ARCH=$(uname -m)

DATE=$(date "+%a %b %d %I:%M:%S %p %Z %Y")

LOAD=$(cut -d ' ' -f1 /proc/loadavg)

# STORAGE
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_PCT=$(df -h / | awk 'NR==2 {print $5}')

# MEMORY (human readable)
MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
MEM_USED=$(free -h | awk '/Mem:/ {print $3}')
MEM_PCT=$(free | awk '/Mem:/ {printf "%.0f%%", $3*100/$2}')

# SWAP (human readable)
SWAP_TOTAL=$(free -h | awk '/Swap:/ {print $2}')
SWAP_USED=$(free -h | awk '/Swap:/ {print $3}')
SWAP_PCT=$(free | awk '/Swap:/ {if ($2==0) print "0%"; else printf "%.0f%%", $3*100/$2}')

PROCS=$(ps -e --no-headers | wc -l)
USERS=$(who | wc -l)

# IP FROM IFCONFIG
IP=$(ifconfig 2>/dev/null | awk '
/^[a-zA-Z0-9]/ {iface=$1}
/inet / && iface !~ /^lo/ && iface !~ /^veth/ {
    print $2
}' | paste -sd "," -)

TEMP=$(sensors 2>/dev/null | awk '/temp1/ {print $2; exit}' || echo "N/A")

echo ""
echo "Welcome to $OS (GNU/Linux $KERNEL $ARCH)"
echo "System information as of $DATE"
echo ""
echo "  System load:  $LOAD%              "     
echo "  Storage:      $DISK_USED / $DISK_TOTAL ($DISK_PCT)       IPv4 address:       $IP"
echo "  Memory:       $MEM_USED / $MEM_TOTAL ($MEM_PCT)     Swap:         $SWAP_USED / $SWAP_TOTAL ($SWAP_PCT) "

echo ""
echo "Services:"
echo "Ollama: http://localhost:11434           |   Host SSH: ssh u0_a324@localhost -p 8022"
echo "System Monitor: http://localhost:8027    |   Terminal: http://localhost:8026"
echo "SSH: ssh ubuntu@localhost -p 8028"
