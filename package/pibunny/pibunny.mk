################################################################################
#
# PIBUNNY
#
################################################################################

PIBUNNY_VERSION = 0.0.1
PIBUNNY_SITE = .
PIBUNNY_LICENSE = GPL-2.0+
PIBUNNY_LICENSE_FILES = LICENSE
PIBUNNY_DEST_DIR = /opt/pibunny
PIBUNNY_SITE_METHOD = local
PIBUNNY_INIT_SYSTEMD_TARGET = basic.target.wants

define PIBUNNY_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)$(PIBUNNY_DEST_DIR)
        $(INSTALL) -D -m 0755 $(PIBUNNY_PKGDIR)/pibunny.py $(TARGET_DIR)$(PIBUNNY_DEST_DIR)
        $(INSTALL) -D -m 0644 $(PIBUNNY_PKGDIR)/blinkt_iface.py $(TARGET_DIR)$(PIBUNNY_DEST_DIR)
        $(INSTALL) -D -m 0755 $(PIBUNNY_PKGDIR)/switch.sh $(TARGET_DIR)$(PIBUNNY_DEST_DIR)
        $(INSTALL) -D -m 0755 $(PIBUNNY_PKGDIR)/armingMode.sh $(TARGET_DIR)$(PIBUNNY_DEST_DIR)

        $(INSTALL) -D -m 0755 $(PIBUNNY_PKGDIR)/bin/ATTACKMODE $(TARGET_DIR)/bin
        $(INSTALL) -D -m 0755 $(PIBUNNY_PKGDIR)/bin/LED $(TARGET_DIR)/bin
        $(INSTALL) -D -m 0755 $(PIBUNNY_PKGDIR)/bin/QUACK $(TARGET_DIR)/bin
        ln -sf /bin/QUACK $(TARGET_DIR)/bin/Q

        mkdir -p $(TARGET_DIR)$(PIBUNNY_DEST_DIR)/functions.d/
        $(INSTALL) -D -m 0644 $(PIBUNNY_PKGDIR)/functions/*.sh $(TARGET_DIR)$(PIBUNNY_DEST_DIR)/functions.d/
endef

define PIBUNNY_INSTALL_INIT_SYSTEMD
        mkdir -p $(TARGET_DIR)/etc/systemd/system/$(PIBUNNY_INIT_SYSTEMD_TARGET)
        $(INSTALL) -D -m 644 $(PIBUNNY_PKGDIR)/pibunny.service $(TARGET_DIR)/usr/lib/systemd/system/pibunny.service
        ln -sf /usr/lib/systemd/system/pibunny.service $(TARGET_DIR)/etc/systemd/system/$(PIBUNNY_INIT_SYSTEMD_TARGET)
endef

$(eval $(generic-package))
