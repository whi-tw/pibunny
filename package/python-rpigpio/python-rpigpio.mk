################################################################################
#
# python-rpigpio
#
################################################################################

PYTHON_RPIGPIO_VERSION = 0.7.0
PYTHON_RPIGPIO_SOURCE = RPi.GPIO-$(PYTHON_RPIGPIO_VERSION).tar.gz
PYTHON_RPIGPIO_SITE = https://files.pythonhosted.org/packages/cb/88/d3817eb11fc77a8d9a63abeab8fe303266b1e3b85e2952238f0da43fed4e
PYTHON_RPIGPIO_SETUP_TYPE = distutils

$(eval $(python-package))
