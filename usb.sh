#!/bin/bash

# Задаем имя устройства флешки
device="sda1" # замените это на имя вашего устройства

# Создаем точку монтирования, если она еще не существует
sudo mkdir -p /mnt/usb

# Монтируем флешку
sudo mount "/dev/$device" /mnt/usb

# Проверяем успешность монтирования
if mountpoint -q /mnt/usb; then
    echo "Флешка успешно примонтирована в /mnt/usb"
    # Запускаем файловый менеджер ranger для просмотра содержимого флешки
    ranger /mnt/usb
else
    echo "Не удалось примонтировать флешку."
fi

# Важно: после завершения работы с флешкой, отмонтируйте её безопасно
# sudo umount /mnt/usb
