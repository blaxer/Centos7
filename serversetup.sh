#!/usr/bin/env bash

#This is a simple script used to setup centos7 VM's for testing

#install net tools
yum install net-tools -y

# install delta rpm support
yum install deltarpm -y

#ask user for ip address
echo ipv4 address?
read new_ip_value

# Configure static ip
system-config-network-cmd -i <<EOF
DeviceList.Ethernet.eth0.type=Ethernet
DeviceList.Ethernet.eth0.BootProto=static
DeviceList.Ethernet.eth0.OnBoot=True
DeviceList.Ethernet.eth0.NMControlled=True
DeviceList.Ethernet.eth0.Netmask=192.168.1.255
DeviceList.Ethernet.eth0.IP=${new_ip_value}
DeviceList.Ethernet.eth0.Gateway=192.168.1.1
ProfileList.default.ActiveDevices.1=eth0
EOF

service network stop
service network start

#Set the timezone

timedatectl set-timezone America/Los_Angeles

#Kill the firewall
systemctl stop firewalld
systemctl disable firewalld

#Kill selinux

sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config


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

sudo yum install epel-release -y
sudo yum install -y python-pip 
sudo pip install docker-compose -y
sudo yum upgrade python*

#Install portainer

docker volume create portainer_data
docker run -d --restart always --name Portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer



