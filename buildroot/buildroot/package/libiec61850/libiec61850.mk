################################################################################
#
# libiec61850
#
################################################################################

LIBIEC61850_VERSION = 1.4.2.1
LIBIEC61850_SITE = $(call github,mz-automation,libiec61850,v$(LIBIEC61850_VERSION))
LIBIEC61850_INSTALL_STAGING = YES
LIBIEC61850_LICENSE = GPL-3.0+
LIBIEC61850_LICENSE_FILES = COPYING
LIBIEC61850_CONF_OPTS = -DBUILD_EXAMPLES=OFF \
	-DBUILD_PYTHON_BINDINGS=OFF

$(eval $(cmake-package))
