#!/bin/sh

systemctl stop firewalld && sudo systemctl disable firewalld

# for docker
yum update --assumeyes

# setup kernel module "overlay"
tee /etc/modules-load.d/overlay.conf <<-'EOF'
overlay
EOF
modprobe overlay

# setup docker yum repo.
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# configure systemd to run the Docker Daemon with OverlayFS 
mkdir -p /etc/systemd/system/docker.service.d && sudo tee /etc/systemd/system/docker.service.d/override.conf <<- EOF
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon --storage-driver=overlay -H fd://
EOF

# install docker
yum install --assumeyes --tolerant docker-engine
systemctl start docker
systemctl enable docker

cd /root
curl -O https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh 
#nohup bash ./dcos_generate_config.sh --web &

bash dcos_generate_config.sh --genconf
bash dcos_generate_config.sh --install-prereqs
bash dcos_generate_config.sh --preflight
bash dcos_generate_config.sh --deploy
bash dcos_generate_config.sh --postflight

