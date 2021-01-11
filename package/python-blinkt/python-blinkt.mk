################################################################################
#
# python-blinkt
#
################################################################################

PYTHON_BLINKT_VERSION = 0.1.2
PYTHON_BLINKT_SOURCE = blinkt-$(PYTHON_BLINKT_VERSION).tar.gz
PYTHON_BLINKT_SITE = https://files.pythonhosted.org/packages/c0/33/fb5a3bfc2e9d467a6f9892088f08c0b88b4bbb0237a696b1b25cacab54d5
PYTHON_BLINKT_SETUP_TYPE = setuptools
PYTHON_BLINKT_LICENSE = MIT
PYTHON_BLINKT_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
