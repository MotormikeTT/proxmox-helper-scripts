#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y unzip
$STD apt-get install -y python3-dev
$STD apt-get install -y python3-pip
$STD apt-get install -y python3-distutils
msg_ok "Installed Dependencies"

msg_info "Installing Bazarr"
mkdir -p /opt/bazarr
cd /opt/bazarr
wget -q 'https://github.com/morpheus65535/bazarr/releases/latest/download/bazarr.zip'
$STD unzip bazarr.zip
rm -rf bazarr.zip
chmod +x bazarr
$STD python3 -m pip install -r requirements.txt
msg_ok "Installed Bazarr"

msg_info "Creating Service"
service_path="/etc/systemd/system/bazarr.service"
echo "[Unit]
Description=Bazarr
After=network.target
[Service]
WorkingDirectory=/opt/bazarr
ExecStart=python3 bazarr.py -s 0.0.0.0:6767
Restart=always
User=root
[Install]
WantedBy=multi-user.target" >$service_path
systemctl enable --now -q bazarr.service
msg_ok "Created Service"

motd_ssh
root

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
