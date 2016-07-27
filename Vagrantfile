'''
/**
 * Tasting Mesos DC/OS
 *
 * Vagrantfile for Linux Containers Mesos DC/OS (Operating System Level Virtualization)
 * and also for
 * - tasting my simple python Flask application (over apache/httpd) on docker images
 * @author Adriano Vieira <adriano.svieira at gmail.com>

   Copyright 2016 Adriano dos Santos Vieira

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 * @license @see LICENCE
 */
 '''

VAGRANTFILE_API_VERSION = "2"
OSLV_CPU = 2
OSLV_MEMORY = 1024
OSLV_MANAGER_FQDN = "mesos.dcos"
OSLV_GROUP = 'DC_OS'
OSLV_NODES = 3
OSLV_PVTNET = "192.168.50.10"

ipv4 = OSLV_PVTNET.split('.')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provider "virtualbox" do |virtualbox| # Virtualbox.settings
    virtualbox.customize [ "modifyvm", :id, "--cpus", OSLV_CPU ]
    virtualbox.customize [ "modifyvm", :id, "--memory", OSLV_MEMORY ]
    virtualbox.customize [ "modifyvm", :id, "--name", OSLV_MANAGER_FQDN ]
    virtualbox.customize [ "modifyvm", :id, "--groups", "/#{OSLV_GROUP}" ]
  end # end Virtualbox.settings

  config.vm.box = "adrianovieira/centos7-docker1.12rc4"
  config.vm.box_check_update = false

  # shared folder between host and VM (may be for development porposes)
  config.vm.synced_folder ".", "/home/vagrant/shared"

  config.vm.provision "docker-setup-storage_driver_overlayfs", type: "shell",
          path: "setup/docker-setup-storage_driver_overlayfs.sh"

  config.vm.provision "docker-setup-proxy", type: "shell", path: "setup/docker-setup-proxy.sh"

  config.vm.provision "ssh-id_rsa.pub-setup", type: "shell",
          inline: "sudo cat /home/vagrant/shared/setup/ssh_key-id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"

  (1..(OSLV_NODES)).each do |node_id|
    config.vm.define "dcos_node#{node_id}" do |dcos|  # define-VM DC/OS nodes

      dcos.vm.provision "hostname-setup", type: "shell",
              inline: "sudo hostnamectl set-hostname dcos_node#{node_id}"

      node_ipv4 = [ipv4[0], ipv4[1],ipv4[2], (ipv4[3].to_i+node_id)>=250?(ipv4[3].to_i-node_id):ipv4[3].to_i+node_id ].join('.')
      dcos.vm.network "private_network", ip: node_ipv4 #, virtualbox__intnet: "mesos_dcos_net"

      dcos.vm.provider "virtualbox" do |virtualbox| # Virtualbox.settings
        virtualbox.customize [ "modifyvm", :id, "--name", "dcos_node#{node_id}" ]
      end # end Virtualbox.settings
    end # end-of-define-VM DC/OS nodes
  end # end-of-define-VM-loop node_id

  # DC/OS Master
  config.vm.define "dcos_master" do |dcos|  # define-VM DC/OS nodes
    dcos.vm.provider "virtualbox" do |virtualbox| # Virtualbox.settings
      virtualbox.customize [ "modifyvm", :id, "--memory", 2048 ]
      virtualbox.customize [ "modifyvm", :id, "--name", "dcos_master" ]
    end # end Virtualbox.settings

    # standard sync folder between host and VM (not host shared)
    config.vm.synced_folder "./genconf", "/home/vagrant/dcos-install/genconf", type: "rsync"

    #dcos.vm.network "public_network", ip: OSLV_PVTNET
    dcos.vm.network "forwarded_port", guest: 80, host: 1080
    dcos.vm.network "forwarded_port", guest: 8181, host: 8181
    dcos.vm.network "forwarded_port", guest: 8080, host: 8080

    dcos.vm.provision "hostname-setup", type: "shell",
            inline: "sudo hostnamectl set-hostname dcos_master"

    dcos.vm.provision "ssh_key-setup", type: "shell",
            inline: "sudo cp /home/vagrant/shared/setup/ssh_key-id_rsa /home/vagrant/dcos-install/genconf/ssh_key;
                     sudo chmod 0600 /home/vagrant/dcos-install/genconf/ssh_key;
                     sudo chown vagrant:vagrant /home/vagrant/dcos-install/genconf/ssh_key;
                     sudo cp /home/vagrant/shared/setup/ssh_key-id_rsa /home/vagrant/.ssh/id_rsa;
                     sudo chown vagrant:vagrant /home/vagrant/.ssh/id_rsa;
                     sudo chmod 0600 /home/vagrant/.ssh/id_rsa;"

    dcos.vm.network "private_network", ip: OSLV_PVTNET #, virtualbox__intnet: "mesos_dcos_net"

  end # end-of-define-VM DC/OS nodes

end # end-of-file
