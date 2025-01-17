#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/MotormikeTT/proxmox-helper-scripts/main/misc/build.func)
# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
Bazarr   
                                              
EOF
}
header_info
echo -e "Loading..."
APP="Bazarr"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="11"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET=dhcp
  GATE=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/bazarr ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP"
systemctl stop bazarr.service
RELEASE=$(curl -s https://api.github.com/repos/bazarr/bazarr/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
tar zxvf <(curl -fsSL https://github.com/bazarr/bazarr/releases/download/$RELEASE/Bazarr-${RELEASE}-src.tar.gz) &>/dev/null
\cp -r Bazarr-${RELEASE}/* /opt/bazarr &>/dev/null
rm -rf Bazarr-${RELEASE}
cd /opt/bazarr
python3 -m pip install -r requirements.txt &>/dev/null
systemctl start bazarr.service
msg_ok "Updated $APP"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:6767${CL} \n"
