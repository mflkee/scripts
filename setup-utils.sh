#!/bin/bash

# Обновление системы и установка базовых пакетов
sudo pacman -Syu
sudo pacman -S --needed git base-devel

# Установка yay (AUR Helper)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Установка neovim и других программ
yay -S neovim ranger firefox telegram-desktop redshift geoclue2 

# Установка tmux и TPM (Tmux Plugin Manager)
yay -S tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Установка zsh и oh-my-zsh
sudo pacman -S zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Установка zsh-syntax-highlighting (предполагается, что oh-my-zsh уже установлен)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Добавление строки для активации zsh-syntax-highlighting в .zshrc
echo "source ${(q-)ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# Установка утилит
yay -S xclip bat lsd dust ripgrep tldr gtop procs z

# Обновление кэша шрифтов
fc-cache -fv

# Делаем скрипт исполняемым и запускаем его
chmod +x ~/scripts/setup.sh
~/scripts/setup.sh
