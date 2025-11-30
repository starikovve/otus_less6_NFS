#!/bin/bash

# Обновляем список пакетов
sudo apt-get update

# Устанавливаем NFS клиент
sudo apt-get install -y nfs-common

# Создаем точку монтирования (хотя x-systemd.automount создаст её, лучше убедиться)
sudo mkdir -p /mnt

# Добавляем запись в fstab для автоматического монтирования через systemd
# Используем NFSv3 (vers=3), noauto (чтобы не вешать загрузку, если сеть не поднялась) и automount
echo "192.168.1.102:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" | sudo tee -a /etc/fstab

# Перечитываем конфигурацию systemd
sudo systemctl daemon-reload

# Перезапускаем таргет remote-fs, чтобы применились изменения
sudo systemctl restart remote-fs.target

# Примечание: Монтирование произойдет при первом обращении к /mnt
