#!/usr/bin/env ruby
# setup instructions vor vagrant to install local VMs with debian wheezy that work as a Freifunk node
# This config file will enable to setup and run the vm testnode with:
# # vagrant up testnode

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bmorg/debian-wheezy-i386"

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  # Service machine
  config.vm.define "services" do |node|
    node.vm.hostname = "global-services"
    node.vm.network "private_network",ip: "172.19.0.2", netmask: "255.255.0.0"
    node.vm.provision :shell, path: "bootstrap-services.sh", args: "services"
  end

  ##### Gotham City ####
  
  # Gotham City Gateways
  (0..4).each do |i|
		config.vm.define "gc-gw#{i}" do |node|
			node.vm.hostname = "gc-gw#{i}"
			node.vm.network "private_network", ip: "172.19.1.#{i+1}", netmask: "255.255.0.0"
			node.vm.provision :shell, path: "bootstrap.sh", args: "gc-gw#{i}"
		end
  end
  # Gotham City nodes
  (0..3).each do |i|
		config.vm.define "gc-node#{i}" do |node|
			node.vm.hostname = "gc-node#{i}"
			node.vm.network "private_network",ip: "172.19.1.10#{i+1}", netmask: "255.255.0.0"
			# 																hostname, 		port, 		MESH_CODE, 	MESH_MTU, 	COUNTER, 	IP_RANGE
			node.vm.provision :shell, path: "bootstrap-testnode.sh", args: ["gc-node#{i}",	"10035",	"ffgc", 	"1492", 	"#{i}",		"172.19.1#{i+1}"]
		end
  end
  
  #### Metropolis ####
  (0..1).each do |i|
		config.vm.define "mp-gw#{i}" do |node|
			node.vm.hostname = "mp-gw#{i}"
			node.vm.network "private_network", ip: "172.19.2.#{i+1}", netmask: "255.255.0.0"
			node.vm.provision :shell, path: "bootstrap.sh", args: "mp-gw#{i}"
		end
  end

  #### Smallville ####
  # Has no Gateway itself
  
end
