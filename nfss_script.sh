#!/bin/bash

# Обновляем список пакетов
sudo apt-get update

# Устанавливаем NFS сервер
sudo apt-get install -y nfs-kernel-server

# Создаем директорию для экспорта и поддиректорию upload
sudo mkdir -p /srv/share/upload

# Настраиваем права доступа
sudo chown -R nobody:nogroup /srv/share
sudo chmod 0777 /srv/share/upload

# Добавляем запись в /etc/exports
# Экспортируем только для клиента 192.168.1.96
cat << EOF | sudo tee /etc/exports
/srv/share 192.168.1.96/32(rw,sync,root_squash)
EOF

# Экспортируем директории
sudo exportfs -r

# Проверяем статус (для логов при провижининге)
sudo exportfs -s

# Перезапускаем сервис для надежности
sudo systemctl restart nfs-kernel-server
