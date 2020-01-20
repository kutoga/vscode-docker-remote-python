#!/bin/bash
set -e

echo "##################################################################"
echo "During the installation, it might be required that you several"
echo "times have to input your password. If a shell is opened, please"
echo "close it with 'exit'."
echo ""
echo "Please press a key to continue..."
echo "##################################################################"
read

# Install packages
sudo apt-get update
sudo apt-get install -y vim zsh curl toilet git tmux screen python ncdu

# Install oh-my-zsh
(
    # Delete oh-my-zsh, if it already exists
    cd ~
    rm -Rf .oh-my-zsh
    if [ -f .zshrc ]; then
        mv .zshrc .zshrc_old
    fi

    # Download & install
    (
        echo "y"
        echo "exit"
    ) | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # Install autosuggest
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    chmod g-w,o-w ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
)

# Install home-files
(
    cd "$(dirname "$0")"
    cp -rT home ~
)

# Changed are done to oh-my-zsh: Commit them (this is required for oh-my-zsh upgrades)
(
    cd ~
    cd .oh-my-zsh/
    git config user.email "$(whoami)@localhost"
    git config user.name "$(whoami)"
    git add .
    git commit -a -m "Customizations"
)

# Install fzf
(
    cd ~
    rm -Rf .fzf/
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    yes y | ~/.fzf/install
)

# Install autojump
(
    cd /tmp
    git clone --depth 1 git://github.com/wting/autojump.git
    cd autojump
    python ./install.py || echo 'Got an error, but ignore it (this might happen)'
    cd ..
    rm -Rf autojump
)

# Install forgit
(
    git clone --depth 1 https://github.com/wfxr/forgit ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/forgit
    chmod g-w,o-w ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/forgit
)

# Install zsh syntax highlighting
(
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    chmod g-w,o-w ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
)

# Install alias-tips
(
    git clone --depth 1  https://github.com/djui/alias-tips ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips
    chmod g-w,o-w ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips
)

# Are we running on WSL? In this case, some additional aliases have to be added
if [ ! -z "$(cat /proc/sys/kernel/osrelease | grep Microsoft)" ]; then
    (
        cd ~
        mkdir -p .zshrc_custom
        target_f=.zshrc_custom/00_wsl
        cat > $target_f <<EOL
alias exp="explorer.exe ."
alias clip="clip.exe"
alias dotnet="dotnet.exe"

# Port the windows cmd.exe "start"-command to wsl
function start {
  (
    for f in \$@; do
      cmd.exe /C "\$f" &
    done
  ) 1>/dev/null 2>/dev/null
}

# Add a function to convert windows paths to wsl paths
function win2wslP {
  # See: https://gist.github.com/aseering/a06219e74c7f96ccea5ec65d5b2483b5
  echo "\$@" | sed -e 's|\\\\|/|g' -e 's|^\([A-Za-z]\)\:/\(.*\)|/mnt/\L\1\E/\2|'
}

# Add a function to open a sln file (Visual Studio solution) iff there is one sln
# in the current directory.
sln () {
    sln_files=\$(find . -maxdepth 1 -type f -name '*.sln' -printf '%P\\n')
    if [ "\$(echo $sln_files | wc -l)" -eq "1" ]; then
        start \$sln_files
    fi
}

EOL
    )
fi

# Change shell
echo "If required enter your password to change the shell:"
chsh -s /bin/zsh

