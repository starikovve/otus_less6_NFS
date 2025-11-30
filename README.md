# otus_less6_NFS

Administrator Linux. Professional

Работа с NFS

Создаём 2 виртуальные машины с сетевыми интерфейсами, которые позволяют связь между ними.

Далее будем называть ВМ с NFS сервером nfss (IP 192.168.5.102), а ВМ с клиентом nfsc (IP 192.168.1.96).

Настраиваем сервер NFS:

Установим сервер NFS:
apt install nfs-kernel-server
Настройки сервера находятся в файле /etc/nfs.conf 
Проверяем наличие слушающих портов 2049/udp, 2049/tcp,111/udp, 111/tcp (не все они будут использоваться далее,  но их наличие сигнализирует о том, что необходимые сервисы готовы принимать внешние подключения):

ss -tnplu 

<img width="1347" height="170" alt="image" src="https://github.com/user-attachments/assets/1e221357-00ba-4777-9513-d9fa59e749f4" />

Создаём и настраиваем директорию, которая будет экспортирована в будущем 

root@nfss:~# mkdir -p /srv/share/upload
root@nfss:~# chown -R nobody:nogroup /srv/share
root@nfss:~# chmod 0777 /srv/share/upload

<img width="435" height="61" alt="image" src="https://github.com/user-attachments/assets/641b94f1-c51f-4a5d-a891-7838881ae7d0" />


Cоздаём в файле /etc/exports структуру, которая позволит экспортировать ранее созданную директорию:

root@nfss:~# cat << EOF > /etc/exports
/srv/share 192.168.1.96/32(rw,sync,root_squash)
EOF

Экспортируем ранее созданную директорию:

root@nfss:~# exportfs -s

<img width="1058" height="64" alt="image" src="https://github.com/user-attachments/assets/97287380-3cfe-45fd-84ab-90a57033d6d2" />


Настраиваем клиент NFS 

Заходим на сервер с клиентом.
Дальнейшие действия выполняются от имени пользователя имеющего повышенные привилегии, разрешающие описанные действия. 
Установим пакет с NFS-клиентом
root@nfsc:~# sudo apt install nfs-common

Добавляем в /etc/fstab строку 


echo "192.168.1.102:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab

и выполняем команды:

root@nfsc:~# systemctl daemon-reload 
root@nfsc:~# systemctl restart remote-fs.target 

Отметим, что в данном случае происходит автоматическая генерация systemd units в каталоге /run/systemd/generator/, которые производят монтирование при первом обращении к каталогу /mnt/.
Заходим в директорию /mnt/ и проверяем успешность монтирования:

root@nfsc:~# mount | grep mnt 

<img width="1016" height="63" alt="image" src="https://github.com/user-attachments/assets/b8f75e3b-3676-4b3f-b576-042ab8b73ad9" />








