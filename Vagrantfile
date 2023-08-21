# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configure the VMs
Vagrant.configure("2") do |config|

  # Use Ubuntu as the box
  config.vm.box = "ubuntu/focal64"

  config.vm.provision "shell", path: "provision/provision_vm.sh"
end
