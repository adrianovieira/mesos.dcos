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

  if [[ "$HTTP_PROXY" != "http://proxy_not_set:3128" ]]; then
    echo "INFO: [docker-setup-proxy.sh] setting docker service proxy ($HTTP_PROXY)"
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo echo "[Service]" > /tmp/proxy.conf
    sudo echo "Environment='HTTPS_PROXY=$HTTP_PROXY' 'HTTP_PROXY=$HTTP_PROXY'" >> /tmp/proxy.conf
    sudo mv /tmp/proxy.conf /etc/systemd/system/docker.service.d/proxy.conf
    sudo systemctl daemon-reload && sudo systemctl restart docker
  fi

fi

if [[ "$?" == 0 ]]; then
  echo "INFO: [docker-setup-proxy.sh] finished"
else
  exit 1
fi
