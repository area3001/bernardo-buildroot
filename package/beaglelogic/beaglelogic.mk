################################################################################
#
# BeagleLogic firmware and tcp-server
#
################################################################################
BEAGLELOGIC_VERSION = 3cea157d312a685547a2ca9aa66cefacd1fd2cee
BEAGLELOGIC_SITE = https://github.com/abhishek-kakkar/BeagleLogic.git
BEAGLELOGIC_SITE_METHOD = git
BEAGLELOGIC_DEPENDENCIES = host-ti-cgt-pru host-pru-software-support host-go
BEAGLELOGIC_LICENSE = GPLv2
BEAGLELOGIC_LICENSE_FILES = LICENSE

define BEAGLELOGIC_BUILD_FIRMWARE_CMDS
	$(MAKE) PRU_CGT=$(TI_CGT_PRU_INSTALLDIR) PRU_SP_PATH=$(TI_CGT_PRU_INSTALLDIR)/usr -C $(@D)/firmware all
endef

define BEAGLELOGIC_BUILD_TCP_SERVER
	$(HOST_GO_TARGET_ENV) $(HOST_DIR)/bin/go build -v -o $(@D)/tcp-server-go/tcp-server-go $(@D)/tcp-server-go/server.go
endef

define BEAGLELOGIC_INSTALL_FIRMWARE_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/lib/firmware
	$(INSTALL) -m 0755 $(@D)/firmware/release/beaglelogic-pru0.out $(TARGET_DIR)/lib/firmware/beaglelogic-pru0-fw
	$(INSTALL) -m 0755 $(@D)/firmware/release/beaglelogic-pru1.out $(TARGET_DIR)/lib/firmware/beaglelogic-pru1-logic
	# make it a symlink so that we can easily swap out the PRU firmware
	ln -sfv beaglelogic-pru1-logic $(TARGET_DIR)/lib/firmware/beaglelogic-pru1-fw
endef

define BEAGLELOGIC_INSTALL_UDEV_CMDS
	$(INSTALL) -D -m 0755 $(@D)/scripts/90-beaglelogic.rules $(TARGET_DIR)/etc/udev/rules.d/
endef

define BEAGLELOGIC_INSTALL_TCP_SERVER
	$(INSTALL) -m 0755 $(BEAGLELOGIC_PKGDIR)/S70tcp-server-go $(TARGET_DIR)/etc/init.d/S70tcp-server-go
	$(INSTALL) -m 0755 $(@D)/tcp-server-go/tcp-server-go $(TARGET_DIR)/usr/sbin/tcp-server-go
endef

define BEAGLELOGIC_BUILD_CMDS
	$(BEAGLELOGIC_BUILD_FIRMWARE_CMDS)
	$(BEAGLELOGIC_BUILD_TCP_SERVER)
endef

define BEAGLELOGIC_INSTALL_TARGET_CMDS
	$(BEAGLELOGIC_INSTALL_FIRMWARE_CMDS)
	$(BEAGLELOGIC_INSTALL_UDEV_CMDS)
	$(BEAGLELOGIC_INSTALL_TCP_SERVER)
endef

$(eval $(generic-package))
