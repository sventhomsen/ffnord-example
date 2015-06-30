#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bmorg/debian-wheezy-i386"

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # Service machine
  config.vm.define "services" do |node|
    node.vm.hostname = "global-services"
    node.vm.network "private_network",ip: "172.19.0.2", netmask: "255.255.0.0"
    node.vm.provision :shell, path: "bootstrap-services.sh", args: "services"
  end

  # Gotham City Gateways
  (0..4).each do |i|
		config.vm.define "gc-gw#{i}" do |node|
			node.vm.hostname = "gc-gw#{i}"
			node.vm.network "private_network", ip: "172.19.1.#{i+1}", netmask: "255.255.0.0"
			node.vm.provision :shell, path: "bootstrap.sh", args: "gc-gw#{i}"
		end
  end


  # Metropolis
  (0..1).each do |i|
        config.vm.define "mp-gw#{i}" do |node|
            node.vm.hostname = "mp-gw#{i}"
            node.vm.network "private_network", ip: "172.19.2.#{i+1}", netmask: "255.255.0.0"
            node.vm.provision :shell, path: "bootstrap.sh", args: "mp-gw#{i}"
        end
  end
  
  # create a node vagrant box:
  # enter the gluon-ffki-0.7-x86-virtualbox.vdi into vmware, call it "ffgc-node" and add it to vboxnet1
  # on your host enter
  # #sudo ip addr flush vboxnet1
  # #sudo ip addr add 192.168.1.2 dev vboxnet1
  # #ip route add 192.168.1.1/32 via 192.168.1.2 dev vboxnet1
  # enter http://192.168.1.1 in browser
  # create a node hostname gc-node with mac: 08:00:27:e7:4a:b3, add the password: vagrant for root
  # fastdkey: 4b0354417198222f1c3f0622c7e1d5b47272eb548afb1d1903838e8970bb3e01
  # create a vagrant box from the virtualbox with:
  # #vagrant package --base ffgc-node --output ./gc-node.box
  # #vagrant box add ffgc-node node-image/gc-node.box 

  config.vm.box = "node-image/gc-node.box"

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "64"]
  end
  (0..9).each do |i|
        config.vm.define "gc-node0#{i}" do |node|
            node.vm.hostname = "gc-node0#{i}"
            node.vm.network "private_network", ip: "10.112.222.#{i+1}", netmask: "255.255.0.0"
            #node.vm.provision :shell, path: "bootstrap.sh", args: "node0#{i}"
        end
  end
end
