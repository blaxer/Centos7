#!/usr/bin/env bash

#This is a simple setup script used for centos7 test VM's - assumes running as root

#install net tools
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install Net Tools"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
yum install net-tools -y

# install delta rpm support
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install Delta RPM"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
yum install deltarpm -y

#Set the timezone
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Set Timezone"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
timedatectl set-timezone America/Los_Angeles

#Kill the firewall
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Kill Firewall"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
systemctl stop firewalld
systemctl disable firewalld

#Kill selinux
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Kill SeLinux"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

#Setup automatic yum updates
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Setup Yum Automatic Updates Cron"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
yum -y install yum-cron
systemctl enable yum-cron.service
systemctl start yum-cron.service

#Install docker CE Repo
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install docker CE Repo"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#Install docker CE
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install docker CE"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
yum install -y docker-ce
systemctl enable docker
systemctl start docker

#Install docker compose
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install docker compose"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"

yum install epel-release -y
yum install -y python-pip 
pip install --upgrade pip
pip install docker-compose
yum upgrade python* -y

#Install portainer
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install portainer"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
docker volume create portainer_data
docker run -d --restart always --name Portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

#Install nfs utils
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install nfs utils"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
yum install nfs-utils -y

#Install wget
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install wget"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"
yum install wget -y

#Install watchtower
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install watchtower"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"

docker run -d \
  --restart always \
  --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e WATCHTOWER_NOTIFICATIONS=email \
  -e WATCHTOWER_NOTIFICATION_EMAIL_FROM=watchtower@mailserver.com \
  -e WATCHTOWER_NOTIFICATION_EMAIL_TO=admin@mailserver.com \
  -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER=mail.mailserver.com \
  -e WATCHTOWER_NOTIFICATION_EMAIL_SERVER_TLS_SKIP_VERIFY=true \
  -e WATCHTOWER_NOTIFICATIONS_LEVEL=debug \
  v2tec/watchtower \
  --cleanup 
  
#Install yum update
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "Install yum update"
echo "-----------------------------------------------------------------------------------$(tput sgr 0)"  
yum update -y