#!/bin/bash

# Store the setup directory
SETUP_DIR=$(pwd)

# Variable for pretty printing between sections and a new line
PRETTY_PRINT="\n========================================"

# Check if vim is installed
if ! [ -x "$(command -v vim)" ]; then
    echo "Vim is not installed. Please install vim first."
    echo "for Ubuntu: sudo apt install vim"
    echo "for Mac: brew install vim"
    exit 1
else
    echo "Vim version: $(vim --version | head -n 1)"
    echo "Setting up vim..."
fi


# Check the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VIMRC_DESTINATION="$HOME/.vimrc"
    OS="linux"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    VIMRC_DESTINATION="$HOME/.vimrc"
    OS="mac"

elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows
    VIMRC_DESTINATION="$HOME/vimfiles/vimrc"
    OS="windows"
else
    echo "Unsupported operating system"
    exit 1
fi

# Create the following folder structure
# .vim/
#   ├── autoload/
#   ├── backup/
#   ├── colors/
#   └── plugged/
echo -e $PRETTY_PRINT
echo "CREATING THE FOLDER STRUCTURE..."
mkdir -p "$HOME/.vim/autoload"
mkdir -p "$HOME/.vim/backup"
mkdir -p "$HOME/.vim/colors"
mkdir -p "$HOME/.vim/plugged"
# If tree is installed, display the folder structure
if [ -x "$(command -v tree)" ]; then
    tree "$HOME/.vim"
else
    echo "$HOME/.vim/"
    echo "├── autoload/"
    echo "├── backup/"
    echo "├── colors/"
    echo "└── plugged/"
fi

# Move into the colors folder
cd "$HOME/.vim/colors"
# Download the colorscheme
echo -e $PRETTY_PRINT
echo "DOWNLOADING COLOR CHEME..."
curl -o molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
# Move back to the setup directory
cd "$SETUP_DIR"

# Download the vim-plug plugin manager
echo -e $PRETTY_PRINT
echo "DOWNLOADING VIM-PLUG..."
if $OS == "windows"; then
    curl -fLo $HOME/vimfiles/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Copy .vimrc to its correct destination if the file exists in the current directory
echo -e $PRETTY_PRINT
echo "SETTING UP .vimrc..."
if [ -f ".vimrc" ]; then
    cp .vimrc "$VIMRC_DESTINATION"
else
    echo "No .vimrc file found in the current directory"
    exit 1
fi

# source the .vimrc file
echo -e $PRETTY_PRINT
echo "SOURCING .vimrc..."
source "$VIMRC_DESTINATION"

# Download plugins mentioned in .vimrc
echo -e $PRETTY_PRINT
echo "INSTALLING PLUGINS..."
vim +PlugInstall +qall


echo -e $PRETTY_PRINT
echo "VIM SETUP COMPLETE!"