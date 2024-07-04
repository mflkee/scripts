#!/bin/bash

# Путь к вашему репозиторию с dotfiles
CONFIG_REPO=~/dotfiles

# Начальный массив директорий из корня репозитория, которые нужно синхронизировать
declare -a CONFIG_DIRS=("alacritty" "bluetuith" "bspwm" "neofetch" "polybar" "ranger" "redshift" "sxhkd")

# Функция для загрузки массива CONFIG_DIRS из файла
load_dirs() {
  if [[ -f config_dirs.txt ]]; then
    mapfile -t CONFIG_DIRS < config_dirs.txt
  fi
}

# Вызов функции load_dirs
load_dirs

# Функция для добавления новых директорий в массив CONFIG_DIRS
add_new_dirs() {
  # Ищем все директории в репозитории dotfiles, исключая .git, и добавляем их в массив, если их нет
  for dir in $(find $CONFIG_REPO -mindepth 1 -maxdepth 1 -type d \( ! -name ".git" \) -exec basename {} \;); do
    if [[ ! " ${CONFIG_DIRS[@]} " =~ " ${dir} " ]]; then
      CONFIG_DIRS+=("$dir")
      echo "Добавлена новая директория: $dir"
    fi
  done
}

# Функция для сохранения массива CONFIG_DIRS в файл
save_dirs() {
  printf "%s\n" "${CONFIG_DIRS[@]}" > config_dirs.txt
}

# Функция для создания символических ссылок для директорий
link_config_dirs() {
  for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$CONFIG_REPO/$dir" ]; then
      # Проверяем, существует ли директория в ~/.config и является ли она символической ссылкой
      if [ -L ~/.config/"$dir" ]; then
        # Удаляем существующую символическую ссылку, если она есть
        rm -f ~/.config/"$dir"
      elif [ -d ~/.config/"$dir" ]; then
        # Если это директория, но не ссылка, переименовываем её для бэкапа
        mv ~/.config/"$dir" ~/.config/"$dir".backup
      fi
      # Создаем символическую ссылку для директории
      ln -sfn "$CONFIG_REPO/$dir" ~/.config/"$dir"
    else
      echo "Директория $dir не найдена в репозитории dotfiles."
    fi
  done
}

# Функция для создания символических ссылок для отдельных файлов
link_individual_files() {
  # Создаем или перезаписываем символические ссылки для отдельных файлов
  ln -sfn $CONFIG_REPO/.zshrc ~/.zshrc
  ln -sfn $CONFIG_REPO/.tmux.conf ~/.tmux.conf
  ln -sfn $CONFIG_REPO/user-dirs.locale ~/user-dirs.locale
  ln -sfn $CONFIG_REPO/user-dirs.dirs ~/user-dirs.dirs
  
  # Добавьте здесь другие файлы, если необходимо
}

# Вызываем функции для добавления новых директорий и создания символических ссылок
add_new_dirs
link_config_dirs
link_individual_files

# Сохраняем состояние массива CONFIG_DIRS после добавления новых директорий
save_dirs

echo "Символические ссылки созданы или обновлены."
