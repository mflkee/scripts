#!/bin/bash

# Путь к вашему репозиторию с dotfiles
CONFIG_REPO=~/dotfiles

# Начальный массив директорий из корня репозитория, которые нужно синхронизировать
declare -a CONFIG_DIRS=("alacritty" "bluetuith" "bspwm" "neofetch" "polybar" "ranger" "redshift" "sxhkd")

# Функция для добавления новых директорий в массив CONFIG_DIRS
add_new_dirs() {
  # Загружаем текущее состояние массива из файла
  if [[ -f config_dirs.txt ]]; then
    mapfile -t current_dirs < config_dirs.txt
  else
    declare -a current_dirs=()
  fi

  # Ищем все директории в репозитории dotfiles, исключая .git
  for dir in $(find $CONFIG_REPO -mindepth 1 -maxdepth 1 -type d -not -path "$CONFIG_REPO/.git" -exec basename {} \;); do
    # Проверяем, есть ли директория в текущем массиве
    if [[ ! " ${current_dirs[@]} " =~ " ${dir} " ]]; then
      CONFIG_DIRS+=("$dir")
      echo "**Добавлена новая директория:** $dir"
    fi
  done
}

# Вызываем функцию для добавления новых директорий
add_new_dirs

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
  for dir in $(find $CONFIG_REPO -mindepth 1 -maxdepth 1 -type d -not -path "$CONFIG_REPO/.git" -exec basename {} \;); do
    if [[ ! " ${CONFIG_DIRS[@]} " =~ " ${dir} " ]]; then
      CONFIG_DIRS+=("$dir")
      echo "**Добавлена новая директория:** $dir"
    fi
  done
}

# Функция для сохранения массива CONFIG_DIRS в файл
save_dirs() {
  printf "%s\n" "${CONFIG_DIRS[@]}" > config_dirs.txt
}

link_config_dirs() {
  for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$CONFIG_REPO/$dir" ]; then
      # Создаем символическую ссылку для самой директории
      ln -sfn "$CONFIG_REPO/$dir" ~/.config/"$dir"
      # Рекурсивно перебираем все файлы и поддиректории внутри директории
      find "$CONFIG_REPO/$dir" -mindepth 1 -type f | while read file; do
        # Получаем относительный путь файла относительно папки $dir
        relative_path=${file#$CONFIG_REPO/$dir/}
        # Создаем все необходимые поддиректории
        mkdir -p "$(dirname ~/.config/$dir/$relative_path)"
        # Создаем символическую ссылку для файла
        ln -sfn "$file" ~/.config/"$dir/$relative_path"
      done
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
