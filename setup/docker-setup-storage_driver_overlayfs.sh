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

  echo "INFO: [docker-setup-storage_driver_overlayfs.sh] setting docker service storage driver to overlay"
  sudo systemctl stop docker
  sudo mkdir -p /etc/systemd/system/docker.service.d
  sudo cp /home/vagrant/shared/setup/docker-setup-storage_driver_overlayfs.conf /etc/systemd/system/docker.service.d/docker_overlayfs.conf
  sudo systemctl daemon-reload && sudo systemctl restart docker

fi

if [[ "$?" == 0 ]]; then
  echo "INFO: [docker-setup-storage_driver_overlayfs.sh] finished"
else
  exit 1
fi
