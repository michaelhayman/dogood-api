# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.network :forwarded_port, guest: 3003, host: 3003

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # Use Chef Solo to provision our virtual machine
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = [ "cookbooks", "site-cookbooks" ]

    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "vim"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "postgresql::client"

    # Install Ruby 2.2.1 and Bundler
    chef.json = {
      rbenv: {
        user_installs: [{
          user: 'vagrant',
          rubies: [ "2.2.1" ],
          global: "2.2.1",
          gems: {
            "2.2.1" => [
              {
                name: "bundler",
                version: "1.10.6"
              }
            ]
          }
        }]
      },
      postgresql: {
        password: {
          postgres: "iloverandompasswordsbutthiswilldo"
        }
      }
    }
  end
end

