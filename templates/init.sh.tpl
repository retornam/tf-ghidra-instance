#!/usr/bin/env bash


export DEBIAN_FRONTEND=noninteractive

GHIDRA_IMAGE_VERSION="${docker_image_version}"
GHIDRA_USERS="${ghidra_users}"

mkdir -p /home/ubuntu/repos
apt-get -y update
apt-get -y upgrade
apt-get -y install ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

mkdir -p /etc/docker/compose/ghidra


cat <<EOF >>/etc/systemd/system/docker-compose@.service
[Unit]
Description=%i service with docker compose
PartOf=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=true
WorkingDirectory=/etc/docker/compose/%i
ExecStart=/usr/bin/docker compose up -d --remove-orphans
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >> /etc/docker/compose/ghidra/env.conf
GHIDRA_USERS=$GHIDRA_USERS
EOF

cat <<EOF >> /etc/docker/compose/ghidra/docker-compose.yml
services:
   ghidra: 
     image: retornam/ghidra-server:$GHIDRA_IMAGE_VERSION
     env_file: env.conf
     ports:
       - '13100:13100'
       - '13101:13101'
       - '13102:13102'
     volumes:
       - /home/ubuntu/repos:/repos
EOF


systemctl enable docker-compose@ghidra
systemctl start docker-compose@ghidra

echo "DONE" > /home/ubuntu/INITDONE
