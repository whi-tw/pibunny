################################################################################
#
# RSPIDUCKY
#
################################################################################

RSPIDUCKY_VERSION = 0.0.1
RSPIDUCKY_SITE = .
# RSPIDUCKY_LICENSE = GPL-2.0+
# RSPIDUCKY_LICENSE_FILES = LICENSE
RSPIDUCKY_DEST_DIR = /root
RSPIDUCKY_SITE_METHOD = local

define RSPIDUCKY_BUILD_CMDS
	$(TARGET_CC) -o $(RSPIDUCKY_PKGDIR)/hid-gadget-test.o $(RSPIDUCKY_PKGDIR)/src/hid-gadget-test.c
        $(TARGET_CC) -o $(RSPIDUCKY_PKGDIR)/usleep.o $(RSPIDUCKY_PKGDIR)/src/usleep.c
endef


define RSPIDUCKY_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)$(RSPIDUCKY_DEST_DIR)
        $(INSTALL) -D -m 0755 $(RSPIDUCKY_PKGDIR)/hid-gadget-test.o $(TARGET_DIR)$(RSPIDUCKY_DEST_DIR)/hid-gadget-test
        $(INSTALL) -D -m 0755 $(RSPIDUCKY_PKGDIR)/usleep.o $(TARGET_DIR)$(RSPIDUCKY_DEST_DIR)/usleep
        $(INSTALL) -D -m 0755 $(RSPIDUCKY_PKGDIR)/src/duckpi.sh $(TARGET_DIR)$(RSPIDUCKY_DEST_DIR)
        sed -i 's@home/pi@root@g' $(TARGET_DIR)$(RSPIDUCKY_DEST_DIR)/duckpi.sh
        
endef

$(eval $(generic-package))
