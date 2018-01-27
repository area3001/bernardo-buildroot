################################################################################
#
# BeagleLogic firmware
#
################################################################################
BEAGLELOGIC_VERSION = master
BEAGLELOGIC_SITE = https://github.com/abhishek-kakkar/BeagleLogic.git
BEAGLELOGIC_SITE_METHOD = git
BEAGLELOGIC_DEPENDENCIES = host-ti-cgt-pru host-pru-software-support
BEAGLELOGIC_LICENSE = GPLv2
BEAGLELOGIC_LICENSE_FILES = LICENSE

define BEAGLELOGIC_BUILD_FIRMWARE_CMDS
	$(MAKE) PRU_CGT=$(TI_CGT_PRU_INSTALLDIR) PRU_SP_PATH=$(TI_CGT_PRU_INSTALLDIR)/usr -C $(@D)/firmware all
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

define BEAGLELOGIC_BUILD_CMDS
	$(BEAGLELOGIC_BUILD_FIRMWARE_CMDS)
endef

define BEAGLELOGIC_INSTALL_TARGET_CMDS
	$(BEAGLELOGIC_INSTALL_FIRMWARE_CMDS)
	$(BEAGLELOGIC_INSTALL_UDEV_CMDS)
endef

$(eval $(generic-package))
