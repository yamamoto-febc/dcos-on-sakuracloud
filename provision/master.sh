#!/bin/sh

systemctl stop firewalld && sudo systemctl disable firewalld
#curl -O https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh
#bash dcos_generate_config.sh --web
