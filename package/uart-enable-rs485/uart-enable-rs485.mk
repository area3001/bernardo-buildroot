################################################################################
#
# uart-enable-rs485
#
################################################################################

TARGET_CFLAGS += -c -Wall -O2

define UART_ENABLE_RS485_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) \
		$(UART_ENABLE_RS485_PKGDIR)/main.c -o $(@D)/uart-enable-rs485.o

	$(TARGET_CC) $(@D)/uart-enable-rs485.o -o $(@D)/uart-enable-rs485
endef

define UART_ENABLE_RS485_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/uart-enable-rs485 $(TARGET_DIR)/usr/bin/uart-enable-rs485
endef

$(eval $(generic-package))
