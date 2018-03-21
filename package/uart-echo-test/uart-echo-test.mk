################################################################################
#
# uart-echo-test
#
################################################################################

define UART_ECHO_TEST_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(UART_ECHO_TEST_PKGDIR)/main.c -o $(@D)/uart-echo-test
endef

define UART_ECHO_TEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/uart-echo-test $(TARGET_DIR)/usr/sbin/uart-echo
endef

$(eval $(generic-package))
