#!/usr/bin/env bash

#This is a simple setup script used for centos7 test VM's - assumes running as root

#install net tools
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "$Install Net Tools"
echo "$-----------------------------------------------------------------------------------(tput sgr 0)"
yum install net-tools -y

# install delta rpm support
echo "$(tput setaf 6)-----------------------------------------------------------------------------------"
echo "$Install Delta RPM"
echo "$-----------------------------------------------------------------------------------(tput sgr 0)"
yum install deltarpm -y

#Set the timezone
timedatectl set-timezone America/Los_Angeles

#Kill the firewall
systemctl stop firewalld
systemctl disable firewalld

#Kill selinux
sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config

#Setup automatic yum updates
yum -y install yum-cron
systemctl enable yum-cron.service
systemctl start yum-cron.service

#Install docker CE
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl enable docker
systemctl start docker

#Install docker compose
yum install epel-release -y
yum install -y python-pip 
pip install --upgrade pip
pip install docker-compose
yum upgrade python* -y

#Install portainer
docker volume create portainer_data
docker run -d --restart always --name Portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

