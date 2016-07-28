#!/bin/bash

# Copyright 2016 Adriano dos Santos Vieira
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [[ -f /etc/os-release  ]]; then
  . /etc/os-release
fi

if [[ "$ID" == "centos" && "$VERSION_ID" == "7" ]]; then
  echo 'INFO: [dcos-mesos-install_prereqs.sh] Install/Update docker-engine';
  sudo cp /home/vagrant/shared/setup/docker*.repo /etc/yum.repos.d/
  sudo yum clean all
  sudo yum install -y docker-engine
  sudo getent group docker|cut -d: -f4|grep vagrant || sudo usermod -G docker vagrant
  sudo systemctl daemon-reload
  sudo systemctl restart docker

  sudo bash /home/vagrant/shared/setup/docker-setup-proxy.sh

  sudo bash /home/vagrant/shared/setup/docker-setup-storage_driver_overlayfs.sh

  echo "INFO: [dcos-mesos-install_prereqs.sh] Setting pre-reqs for DC/OS"
  sudo yum install -y tar xz unzip curl ipset
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
  sudo sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config
  sudo setenforce 0
  sudo getent group nogroup || sudo groupadd nogroup
  sudo docker pull nginx
  sudo yum install -q -y tar xz unzip curl ipset git
fi

if [[ "$?" == 0 ]]; then
  echo "INFO: [dcos-mesos-install_prereqs.sh] finished"
else
  exit 1
fi
