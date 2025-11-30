# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Используем Ubuntu 24.04 (Noble Numbat) согласно методичке
  config.vm.box = "ubuntu/noble64"

  # Конфигурация сервера NFS
  config.vm.define "nfss" do |nfss|
    nfss.vm.hostname = "nfss"
    nfss.vm.network "private_network", ip: "192.168.1.102"
    # Запуск скрипта настройки сервера
    nfss.vm.provision "shell", path: "nfss_script.sh"
    
    # Настройка ресурсов VirtualBox
    nfss.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end

  # Конфигурация клиента NFS
  config.vm.define "nfsc" do |nfsc|
    nfsc.vm.hostname = "nfsc"
    nfsc.vm.network "private_network", ip: "192.168.1.96"
    # Запуск скрипта настройки клиента
    nfsc.vm.provision "shell", path: "nfsc_script.sh"

    # Настройка ресурсов VirtualBox
    nfsc.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end
end
