#!/bin/bash

# Задержка в секундах
DELAY=1

# Отображение курсора
xdotool mousemove 0 0
xdotool click 1

# Задержка перед выбором области
sleep $DELAY

# Выбираем текущее окно
xdotool selectwindow

# Получаем геометрию текущего окна
WINDOW_GEOMETRY=$(xdotool getwindowgeometry --output format:%x,%y,%w,%h)
# Разделяем значения на x, y, w, h
read -r X Y W H <<< "$WINDOW_GEOMETRY"

# Имя файла скриншота  
screenshot_file="$HOME/screenshots/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png" 

# Выбор области для скриншота
scrot -s -o "$screenshot_file" $X,$Y,$W,$H

# Скрытие курсора
xdotool mousemove 0 0

# Копирование скриншота в буфер обмена
xclip -selection clipboard -t image/png -i "$screenshot_file"

# Сообщение об успешной операции 
echo "Скриншот сохранен в $screenshot_file и скопирован в буфер обмена" 
