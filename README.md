# docklet-core

A light-weighted manager for lxc-cluster based on lxc/ovs/overlayfs/lvm.. , with elasticity, availability, live-upgradable rootfs, live-join machines ..

* Version: 0.3.0

* OS Required: Ubuntu 16.04 x86_64

==============================================================

# Preinstallation on Machines

* git clone https://github.com/ghostplant/docklet-single
* cd docklet-single
* sudo ./docklet-installer.sh

(Reboot is needed if cgroup memory account is not enabled)

# Installation: Single-Node Mode (Default)

[Quickly startup the docklet daemon]
* sudo dl-join

[Open another non-sudo terminal, and test creating a first user cluster]
* test-docklet

# Installation: Multi-Node Cluster Mode

[For cluster configuration]
* sudo gedit /etc/docklet/docklet.conf

Note: Keep same config file among all physical machines!

[SSH-autologin configuration]
* sudo ssh-keygen -t rsa -P ''
* sudo echo ${HOME}/.ssh/id_rsa | sudo tee -a ${HOME}/.ssh/authorized_keys

Note: Keep no-pass login among any pair of physical machines!

[Quickly startup the docklet daemon on each machines]
* sudo dl-join

==============================================================

# Inside Users Containers:

* docklet scaleout

* docklet scalein

* docklet status

* docklet clusterid

* docklet save {image-name}

* docklet remove

* docklet restart

* docklet hosts

* docklet owner

* ...
