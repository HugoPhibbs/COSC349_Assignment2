# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configure the VMs
Vagrant.configure("2") do |config|

  # Use Ubuntu as the box
  config.vm.box = "ubuntu/focal64"

  # Setup port forwarding to docker containers
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Add some extra configuration
  config.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM, otherwise the app runs out of memory:
      vb.memory = "2048"
  end

  # Now provision the VM
  config.vm.provision "shell", path: "provision/provision_vm.sh"
end
