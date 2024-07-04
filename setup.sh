#!/bin/bash

# Путь к вашему репозиторию с dotfiles
CONFIG_REPO=~/dotfiles

# Функция для проверки и добавления новых директорий
check_and_add_dirs() {
  # Ищем все директории в репозитории dotfiles, включая скрытые, исключая .git
  for dir in $(find $CONFIG_REPO -mindepth 1 -maxdepth 1 -type d \( ! -name ".git" \) -exec basename {} \;); do
    # Проверяем, существует ли директория в файловой системе и есть ли она в файле config_dirs.txt
    if [ -d "$CONFIG_REPO/$dir" ] && grep -Fxq "$dir" config_dirs.txt; then
      echo "Директория $dir уже существует и указана в config_dirs.txt"
    else
      echo "Директория $dir не найдена в config_dirs.txt и будет добавлена"
      # Здесь можно добавить код для обработки новой директории
    fi
  done
}

# Функция для создания символических ссылок для директорий
link_config_dirs() {
  for dir in $(cat config_dirs.txt); do
    # Проверяем, существует ли директория в ~/.config и является ли она символической ссылкой
    if [ -d "$CONFIG_REPO/$dir" ]; then
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
  ln -sfn $CONFIG_REPO/.fonts ~/.fonts
  
  # Добавьте здесь другие файлы, если необходимо
}

# Вызываем функции для проверки и добавления новых директорий и создания символических ссылок
check_and_add_dirs
link_config_dirs
link_individual_files

echo "Проверка и добавление директорий завершены. Символические ссылки созданы или обновлены."
