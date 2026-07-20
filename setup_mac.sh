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

# install python #
if ! command -v python3 &> /dev/null
then
    echo "Installing Python..."
    brew install python
else
    echo "Python is already installed ($(python3 --version))."
fi

# install orbstack #
if ! command -v docker &> /dev/null
then
    echo "Installing Orbstack (docker)..."
    brew install --cask orbstack
else
    echo "Orbstack is already installed ($(docker -v))."
fi

# orbstack startup #
echo "Starting Orbstack..."
open /Applications/OrbStack.app/
read -n 1 -s -r -p "When OrbStack is done loading, press any key to continue setup."

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
echo "And, if you are curious, API can be accessed on: http://localhost:8000"
echo "=================================================="
echo "If you want to stop the project, simply type \"docker compose down\" in the console."
