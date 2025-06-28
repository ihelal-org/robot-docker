#!/bin/bash

# Load robot name from config.env
if [[ -f config.env ]]; then
  source config.env
else
  echo "❌ Missing config.env file. Please create one with: ROBOT_NAME=myrobot"
  exit 1
fi

# Ensure scripts are executable
chmod +x scripts/*.sh

# Create workspace
mkdir -p workspace/src

# Install 'just' if missing
if ! command -v just &> /dev/null; then
  echo "📦 Installing 'just'..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &> /dev/null; then
      brew install just
    else
      echo "❌ Homebrew not found. Install it from https://brew.sh"
      exit 1
    fi
  elif [[ -f /etc/debian_version ]]; then
    sudo apt update
    sudo apt install -y just
  else
    echo "❌ Unsupported OS. Install manually: https://github.com/casey/just"
    exit 1
  fi
fi

# Install command stubs (robot-setup, robot-start, etc.)
COMMANDS=(setup build start shell stop)
PROJECT_PATH="$(pwd)"
WRAPPER_TEMPLATE="scripts/robot-wrapper-template.sh"

for CMD in "${COMMANDS[@]}"; do
  TARGET="/usr/local/bin/${ROBOT_NAME}-${CMD}"
  TEMP_SCRIPT="/tmp/${ROBOT_NAME}-${CMD}.sh"

  sed "s|/path/to/your/ros-docker-dev|$PROJECT_PATH|g" "$WRAPPER_TEMPLATE" > "$TEMP_SCRIPT"
  chmod +x "$TEMP_SCRIPT"
  sudo mv "$TEMP_SCRIPT" "$TARGET"

  echo "✅ Installed command: $TARGET"
done

# Setup autocomplete
if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh" ]]; then
  echo "⚙️  Setting up Zsh autocomplete..."
  mkdir -p ~/.zfunc

  cat <<EOF > ~/.zfunc/_${ROBOT_NAME}
#compdef ${ROBOT_NAME}-*
_arguments '*: :($(compgen -c | grep "^${ROBOT_NAME}-"))'
EOF

  # Add to zshrc if not already added
  if ! grep -q 'fpath+=~/.zfunc' ~/.zshrc; then
    echo 'fpath+=~/.zfunc' >> ~/.zshrc
    echo 'autoload -Uz compinit && compinit' >> ~/.zshrc
    echo "✅ Autocomplete config added to ~/.zshrc"
  fi

  # Activate autocomplete immediately in this session
  fpath+=~/.zfunc
  autoload -Uz compinit && compinit
  echo "✅ Autocomplete activated in current Zsh session"

elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == *"bash" ]]; then
  echo "⚙️  Setting up Bash autocomplete..."
  COMPLETION_FILE="/etc/bash_completion.d/${ROBOT_NAME}"

  sudo tee "$COMPLETION_FILE" > /dev/null <<EOF
_robot_commands()
{
  local cur="\${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( \$(compgen -c | grep "^${ROBOT_NAME}-" | grep "\${cur}") )
}
complete -F _robot_commands ${ROBOT_NAME}-*
EOF

  source "$COMPLETION_FILE"
  echo "✅ Autocomplete activated in current Bash session"
else
  echo "⚠️ Shell not detected. Autocomplete skipped."
fi

# Final output
echo ""
echo "🎉 Setup complete!"
echo "👉 You can now use these commands from anywhere:"
for CMD in "${COMMANDS[@]}"; do
  echo "   ${ROBOT_NAME}-${CMD}"
done
echo ""
