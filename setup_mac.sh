#!/bin/bash
echo "U-Skill Wiki installation"

# setup homebrew env if installed but not in PATH #
if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# install homebrew #
if ! command -v brew &> /dev/null
then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> "$HOME/.zprofile"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
else
    echo "Homebrew is already installed ($(brew --version))."
fi

# install docker #
if ! command -v docker &> /dev/null
then
    echo "Installing Docker..."
    brew install docker
else
    echo "Docker is already installed ($(docker -v))."
fi

# install docker-compose #
if ! command -v docker-compose &> /dev/null
then
    echo "Installing Docker Compose..."
    brew install docker-compose
else
    echo "Docker Compose is already installed ($(docker-compose -v))."
fi

# install orbstack #
if [ ! -d "/Applications/OrbStack.app" ]
then
    echo "Installing Orbstack (docker agent)..."
    brew install --cask orbstack
else
    echo "Orbstack is already installed."
fi

# update PATH so we can directly execute docker, docker-compose commands
export PATH="$HOME/.orbstack/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! grep -q "$HOME/.orbstack/bin" "$HOME/.zprofile" 2>/dev/null; then
    echo '\n# Add Orbstack binaries to PATH' >> "$HOME/.zprofile"
    echo 'export PATH="$HOME/.orbstack/bin:$PATH"' >> "$HOME/.zprofile"
fi
if [ -f "$HOME/.zshrc" ] && ! grep -q "$HOME/.orbstack/bin" "$HOME/.zshrc" 2>/dev/null; then
    echo '\n# Add Orbstack binaries to PATH' >> "$HOME/.zshrc"
    echo 'export PATH="$HOME/.orbstack/bin:$PATH"' >> "$HOME/.zshrc"
fi

# orbstack startup #
echo "Starting Orbstack..."
open /Applications/OrbStack.app/

echo "Waiting for Docker service to spool up..."
while ! docker info > /dev/null 2>&1; do
    sleep 2
done

# .env setup lol #
if [ ! -f .env ]; then
    echo "Please fill up the .env file (admin email + password)."
    exit 0
else
    echo "Environment variables are already set."
fi

# project startup!! #
echo "Starting up U-Skill Wiki..."
docker compose up --build -d

echo "=================================================="
echo "Project has been started."
echo "App can be accessed on: http://localhost:8080"
echo "Admin pannel can be accessed on: http://localhost:8080/#/admin"
echo "And, if you are curious, API can be accessed on: http://localhost:8000"
echo "=================================================="
echo "If you want to stop the project, simply type \"docker compose down\" in the console."
