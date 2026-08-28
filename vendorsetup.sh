#!/bin/bash

TFILE=$PWD/out/hapticspath.patched
[ ! -d "out" ]&& mkdir -p out
RET=0
REVERSE=0

cd bootable/recovery
git apply --reverse --check ../../device/infinix/X6711/patches/0001-Change-haptics-activation-file-path.patch || REVERSE=$?
cd ../../

if [ -f "$TFILE" ];then
    echo "haptics path patched already, skipping"
elif [ $REVERSE -eq 0 ]; then
    echo "$TFILE is not found but git is able to reverse haptics path patch, assuming it's already patched, skipping"
else
    cd bootable/recovery
    git apply ../../device/infinix/X6711/patches/0001-Change-haptics-activation-file-path.patch || RET=$?
    cd ../../
    if [ $RET -ne 0 ];then
        echo "ERROR: minuitwrp/events.cpp could not be patched! Vibration in TWRP will not work."
    else
        echo "OK: minuitwrp/events.cpp patched"
        touch $TFILE
    fi
fi

export OF_DISABLE_OTA_MENU=1
export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export OF_DEFAULT_KEYMASTER_VERSION=4.1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_MAINTAINER="nino"
export OF_FLASHLIGHT_ENABLE=0

export FOX_USE_BASH_SHELL=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_XZ_UTILS=1
export FOX_ASH_IS_BASH=1
export OF_ENABLE_LPTOOLS=1
export FOX_DELETE_MAGISK_ADDON=1
export FOX_DELETE_AROMAFM=1
export FOX_ENABLE_APP_MANAGER=1
export OF_SUPPORT_VBMETA_AVB2_PATCHING=1

export FOX_USE_DATA_RECOVERY_FOR_SETTINGS=1

export OF_LOOP_DEVICE_ERRORS_TO_LOG=1

export OF_USE_LZ4_COMPRESSION=true

export OF_SCREEN_H=2400
export OF_STATUS_H=95
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_ALLOW_DISABLE_NAVBAR=0
export OF_CLOCK_POS=1

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_MAXSIZE="5G"
export CCACHE_DIR=".ccache"

if [ ! -d ${CCACHE_DIR} ]; then
  mkdir $CCACHE_DIR
fi

export LC_ALL="C"

device_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_root="$(cd "${device_dir}/../../.." && pwd)"
patch_files=(
	"${device_dir}/patches/0002-Support-direct-file-flashlight-paths.patch"
)

if ! command -v patch >/dev/null 2>&1; then
	echo "[X6711] Missing required command: patch"
else
	for patch_file in "${patch_files[@]}"; do
		patch_name="$(basename "${patch_file}")"
		if [ ! -f "${patch_file}" ]; then
			echo "[X6711] Missing patch: ${patch_file}"
		elif (
			cd "${workspace_root}" &&
			patch -p1 -N --dry-run --silent < "${patch_file}" >/dev/null 2>&1
		); then
			if (
				cd "${workspace_root}" &&
				patch -p1 -N --silent < "${patch_file}" >/dev/null 2>&1
			); then
				echo "[X6711] Applied patch: ${patch_name}"
			else
				echo "[X6711] Failed to apply patch: ${patch_name}"
			fi
		else
			echo "[X6711] Patch already applied or not applicable: ${patch_name}"
		fi
	done
fi

unset device_dir workspace_root patch_files patch_file patch_name
