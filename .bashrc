bash ~/.oh-my-termux/sysinfo.sh

# Ollama + Claude-compatible environment
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_API_KEY=""
export ANTHROPIC_BASE_URL=http://localhost:11434
export ANTHROPIC_DEFAULT_SONNET_MODEL=kimi-k2.6:cloud
export ANTHROPIC_DEFAULT_HAIKU_MODEL=minimax-m2.7:cloud
export ANTHROPIC_DEFAULT_OPUS_MODEL=kimi-k2.5:cloud

git config --global init.defaultBranch main
git config --global user.email "claude@gmail.com"
git config --global user.name "claude"

alias claude="tmux claude"


