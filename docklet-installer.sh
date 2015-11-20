#!/bin/bash

# This script builds docklet with local-deploy mode (1-node), just for testing and development.

set -e

if [[ "`whoami`" != "root" ]]; then
	echo "FAILED: Require root previledge !" > /dev/stderr
	exit 1
fi

if [[ "`cat /proc/cmdline | grep 'cgroup_enable=memory'`" == "" ]]; then
	read -p "[INFO] CGroup memory limit option should be enabled in Linux Kernel! Press ENTER to setup, reboot and re-install docklet again!" > /dev/stderr
	echo 'GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' >> /etc/default/grub && update-grub && reboot
	exit 1
fi

apt-get install -y make cgroup-lite lxc lvm2 bridge-utils nmap curl sshfs netcat-openbsd net-tools psmisc openssh-server openvswitch-switch

make install

curl http://mirrors.ustc.edu.cn/ubuntu-cdimage/ubuntu-core/releases/15.10/beta-2/ubuntu-core-15.10-beta2-core-amd64.tar.gz > filesys.tgz

mkdir -p rootfs && cd rootfs

tar xzvf ../filesys.tgz && rm -f ../filesys.tgz

cp /etc/resolv.conf etc

cp /etc/apt/apt.conf etc/apt

cp /usr/local/bin/apt-clean usr/local/bin

echo "deb http://mirrors.ustc.edu.cn/ubuntu/ wily main restricted multiverse universe" > etc/apt/sources.list

echo "docklet" > etc/hostname

chroot . apt-get update

chroot . apt-get install -y bash-completion vim-tiny psmisc netcat-openbsd inetutils-ping iproute2 net-tools curl p7zip-full openssh-server

cp /etc/vim/vimrc.tiny etc/vim
touch init usr/bin/docklet

sed -i "s/`whoami`@`hostname`//g" etc/ssh/ssh_host_*_key.pub
sed -i 's/\#.*StrictHostKeyChecking ask/StrictHostKeyChecking no/g' etc/ssh/ssh_config
sed -i 's/without-password/yes/g' etc/ssh/sshd_config

chroot . apt-clean

mkdir -p /home/docklet
tar czvf /home/docklet/filesystem.tgz *

cd .. && rm -rf rootfs/

echo "INFO: Current docklet configurations are: " > /dev/stderr

cat /etc/docklet/docklet.conf > /dev/stderr

echo "SUCCEEDED: Finish installion, just run 'dl-join' to boot docklet!" > /dev/stderr

