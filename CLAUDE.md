# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository sets up a full Claude development environment on Android via Termux and proot-distro Ubuntu. It is a shell-script-only project: there are no build systems, tests, or package manifests to maintain. All logic is in Bash.

## High-Level Architecture

**Host layer (Termux)**
- `setup-termux.sh` is the entry point. It installs `proot-distro`, sets up an Ubuntu rootfs, configures Termux SSH (`sshd`), and adds convenience aliases (`ubuntu`, `ubuntu_root`) to `~/.bashrc`.
- On login, Termux auto-starts a tmux session named `service-runner` that runs `utils/start-services.sh` inside the Ubuntu guest.

**Guest layer (Ubuntu via proot-distro)**
- `utils/setup-instance.sh` runs inside Ubuntu and installs: openssh-server, git, ttyd, gh, tmux, curl, wget, zstd, htop, plus `uv`, `ollama`, and the `claude` CLI.
- It also reconfigures the guest SSH daemon to port `8028` and appends a `source ~/.oh-my-termux/.extra_bashrc` line to `~/.bashrc`.

**Environment & Services**
- `.extra_bashrc` is sourced by the guest `~/.bashrc`. It exports Ollama-as-Claude-API variables (`ANTHROPIC_BASE_URL`, `ANTHROPIC_DEFAULT_*_MODEL`, etc.), XDG dirs, and defines helper functions/aliases. The `start_ttyd` function passes `-W utils/ttyd-auth.sh` to ttyd for password authentication. The file ends with `ttyd` and `htop` commands that auto-start the web terminal and monitor on each shell login.
- `utils/start-services.sh` is the service supervisor. It polls every 60 seconds (or once if not `--fg`) and ensures SSH and Ollama are running. It no longer manages `ttyd` or `htop`; those are auto-started by `.extra_bashrc` instead.
- `services/ollama` is an LSB-style init.d script used by the supervisor to start/stop/restart the Ollama daemon.
- `utils/ttyd-auth.sh` is a password credential checker invoked by ttyd (`-W`). It prompts for the user's password and verifies it via `su` before executing the requested command.
- `utils/system-info.sh` prints a welcome banner on login showing system load, storage, memory, swap, and active service endpoints.

**Port Map**
- `11434` — Ollama (`OLLAMA_HOST=0.0.0.0:11434`)
- `8026` — Web terminal (`ttyd` running `bash`)
- `8027` — System monitor (`ttyd` running `htop`)
- `8028` — Guest SSH (Ubuntu)
- `8022` — Host SSH (Termux)

## Key Files and Their Roles

| File | Purpose |
|------|---------|
| `setup-termux.sh` | One-time setup script run from Termux. Clones/pulls this repo and delegates to `utils/setup-instance.sh` inside Ubuntu. |
| `utils/setup-instance.sh` | Guest bootstrap: apt installs, uv/ollama/claude installers, SSH port tweak, wires `.extra_bashrc`. |
| `.extra_bashrc` | Guest environment: Ollama/Claude API vars, `start_ttyd` function (with `-W ttyd-auth.sh`), aliases (`ttyd`, `htop`, `tss`), and auto-starts ttyd/htop on login. |
| `utils/start-services.sh` | Supervisor loop. Invoked by Termux tmux session `service-runner`. Restarts SSH and Ollama if down. |
| `services/ollama` | Init.d script for Ollama; used by the supervisor. Supports `start`, `stop`, `restart`, `status`. |
| `utils/ttyd-auth.sh` | ttyd credential checker (`-W`). Prompts for password and verifies via `su`. |
| `utils/system-info.sh` | Welcome banner printed on guest login. |

## Common Commands

This project has no build or test steps. Relevant operations are manual Bash actions:

- **Re-run guest setup** (e.g., after adding packages to `setup-instance.sh`):
  ```bash
  proot-distro login ubuntu --user ubuntu -- bash -lc "bash /home/ubuntu/.oh-my-termux/utils/setup-instance.sh"
  ```
- **Start services in foreground** (for debugging):
  ```bash
  bash /home/ubuntu/.oh-my-termux/utils/start-services.sh --fg
  ```
  Without `--fg`, the script exits after one pass.
- **Restart Ollama manually**:
  ```bash
  sudo /home/ubuntu/.oh-my-termux/services/ollama restart
  ```
- **Check service status**:
  ```bash
  sudo service ssh status
  sudo /home/ubuntu/.oh-my-termux/services/ollama status
  ```
- **Inspect the supervisor tmux session from Termux**:
  ```bash
  tmux attach -t service-runner
  ```

## Editing Guidelines

- All service logic lives in Bash. Keep scripts POSIX-compatible where feasible; `.extra_bashrc` and `start-services.sh` use Bash-specific features (`[[ ... ]]`) intentionally.
- When adding a new service, follow the existing pattern in `start-services.sh`: check if running, restart if not, and add a matching init script under `services/` if it needs daemon management.
- Avoid hard-coding `ubuntu` user paths in new scripts; use `$HOME` where possible so logic survives if the guest user changes.
- The repo is cloned to `/home/ubuntu/.oh-my-termux` inside the guest. Paths in scripts assume this location.
