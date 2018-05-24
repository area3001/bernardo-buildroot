################################################################################
#
# uart-echo-test
#
################################################################################

CFLAGS = $(TARGET_CFLAGS) -c -Wall -O2

define UART_ECHO_TEST_BUILD_CMDS
	$(TARGET_CC) $(CFLAGS) \
		$(UART_ECHO_TEST_PKGDIR)/main.c -o $(@D)/uart-echo-test.o

	$(TARGET_CC) $(@D)/uart-echo-test.o -o $(@D)/uart-echo-test

	$(TARGET_CC) $(CFLAGS) \
		$(UART_ECHO_TEST_PKGDIR)/send.c -o $(@D)/uart-send-test.o

	$(TARGET_CC) $(@D)/uart-send-test.o -o $(@D)/uart-send-test
endef

define UART_ECHO_TEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/uart-echo-test $(TARGET_DIR)/usr/bin/uart-echo
	$(INSTALL) -D -m 755 $(@D)/uart-send-test $(TARGET_DIR)/usr/bin/uart-send
endef

$(eval $(generic-package))
