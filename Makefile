
install:
	@cp -r kernel/bin/* /usr/local/sbin
	@mkdir -p /etc/docklet
	@cp -r -n conf/docklet.conf /etc/docklet

