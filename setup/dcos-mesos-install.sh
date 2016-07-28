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

DCOS_INSTALLER_DIR="/home/vagrant/shared"
if [[ -f $DCOS_INSTALLER_DIR/dcos_generate_config.sh ]]; then
  echo "INFO: [dcos-mesos-install.sh] Downloading the DC/OS installer"
  wget -c https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh?_ga=1.34663395.314546777.1469460671 -O $DCOS_INSTALLER_DIR/dcos_generate_config.sh
fi

if [[ "$ID" == "centos" && "$VERSION_ID" == "7" ]]; then
  echo "INFO: [dcos-mesos-install.sh] Deploy DC/OS"
  cd /home/vagrant/dcos-install/
  sudo bash $DCOS_INSTALLER_DIR/dcos_generate_config.sh --genconf && \
    sudo bash $DCOS_INSTALLER_DIR/dcos_generate_config.sh --preflight && \
    sudo bash $DCOS_INSTALLER_DIR/dcos_generate_config.sh --deploy && \
    sudo bash $DCOS_INSTALLER_DIR/dcos_generate_config.sh --postflight
fi

if [[ "$?" == 0 ]]; then
  echo "INFO: [dcos-mesos-install.sh] finished"
else
  exit 1
fi
