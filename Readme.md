install this to Termux:

Setup:
```bash
termux-setup-storage
bash <(curl -fsSL -H "Cache-Control: no-cache" -H "Pragma: no-cache" "https://raw.githubusercontent.com/0xAungkon/Full-Claude-Environment-Termux/refs/heads/main/setup-termux.sh?ts=$(date +%s)")

```




proot-distro login ubuntu --user ubuntu -- bash -lc '/home/ubuntu/.oh-my-termux/utils/start-services.sh --fg'


```

git config --global init.defaultBranch main
git config --global user.email "claude@gmail.com"
git config --global user.name "claude"

```