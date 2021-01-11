#!/bin/bash

set -e

GENIMAGE_CFG="$(dirname "$0")/genimage-${BOARDNAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

for arg in "$@"; do
	case "${arg}" in
	--configure-pibunny)
		# Configure pibunny
		if ! grep -qE '^dtoverlay=dwc2,dr_mode=peripheral' "${BINARIES_DIR}/rpi-firmware/config.txt"; then

			cat <<__EOF__ >>"${BINARIES_DIR}/rpi-firmware/config.txt"
dtoverlay=dwc2,dr_mode=peripheral
__EOF__
		fi

		# Set the bootloader delay to 0 seconds
		if ! grep -qE '^boot_delay=0' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat <<__EOF__ >>"${BINARIES_DIR}/rpi-firmware/config.txt"
boot_delay=0
__EOF__
		fi

		# Set turbo mode for boot
		if ! grep -qE '^initial_turbo' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat <<__EOF__ >>"${BINARIES_DIR}/rpi-firmware/config.txt"
initial_turbo=10
__EOF__
		fi

		# Inform the kernel about the filesystem and ro state
		if ! grep -qE 'rootfstype=squashfs ro' "${BINARIES_DIR}/rpi-firmware/cmdline.txt"; then
			sed '/^root=/ s/$/ rootfstype=squashfs ro/' -i "${BINARIES_DIR}/rpi-firmware/cmdline.txt"
		fi

		if ! grep -qE 'modules-load=dwc2,g_serial' "${BINARIES_DIR}/rpi-firmware/cmdline.txt"; then
			sed '/^root=/ s/$/ modules-load=dwc2,g_serial/' -i "${BINARIES_DIR}/rpi-firmware/cmdline.txt"
		fi

		# Suppress kernel output during boot
		# if ! grep -qE 'quiet' "${BINARIES_DIR}/rpi-firmware/cmdline.txt"; then
		# 	sed '/^root=/ s/$/ quiet/' -i "${BINARIES_DIR}/rpi-firmware/cmdline.txt"
		# fi
		;;
	esac

done

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--rootpath "${ROOTPATH_TMP}" \
	--tmppath "${GENIMAGE_TMP}" \
	--inputpath "${BINARIES_DIR}" \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
