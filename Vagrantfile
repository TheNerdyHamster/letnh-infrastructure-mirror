# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = 2
Vagrant.require_version ">= 2.2.0"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "generic/rocky8"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :libvirt do |l|
    l.memory = 512
#    l.linked_clone = true
  end

  config.vm.define "account" do |account|
    account.vm.hostname = "account"
    account.vm.network :private_network, ip: "192.168.30.2"
    account.vm.network "forwarded_port", guest: 389, host: 3389
    account.vm.network "forwarded_port", guest: 686, host: 6686
  end

  # config.vm.define "database" do |database|
  #   database.vm.hostname = "database"
  #   database.vm.network :private_network, ip: "192.168.30.2"
  # end

  # config.vm.define "app2" do |app|
  #   app.vm.hostname = "orc-app2.test"
  #   app.vm.network :private_network, ip: "192.168.32.5"
  # end

  # config.vm.define "db" do |app|
  #   app.vm.hostname = "orc-db.test"
  #   app.vm.network :private_network, ip: "192.168.32.6"
  # end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbooks/basic.yml"
    ansible.groups = {
      "account" => ["account"],
      #"db" => ["db"],
      #"multi:children" => ["db","app"]
    }
  end
end
