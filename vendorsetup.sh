#!/bin/bash

export OF_DISABLE_OTA_MENU=1
export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export OF_DEFAULT_KEYMASTER_VERSION=4.1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_MAINTAINER="nino"
export FOX_VARIANT="R12_nino"
export OF_USE_GREEN_LED=0
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export OF_RECOVERY_AB_FULL_REFLASH_RAMDISK=1
export FOX_SETTINGS_ROOT_DIRECTORY="/persist/OFRP"
export FOX_MISCELLANEOUS_ROOT_DIRECTORY=/sdcard
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

export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1

# List of numbers before scrolling
export FOX_OPTIONS_LIST_NUM=12

# vendor,system、vendor_boot
export FOX_RECOVERY_VENDOR_BOOT_PARTITION="/dev/block/by-name/vendor_boot"
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
	export FOX_RECOVERY_BOOT_PARTITION="/dev/block/by-name/boot"

# Making sure recovery partition exist
export OF_RECOVERY_AB_FULL_REFLASH_RAMDIS=1
	
export OF_LOOP_DEVICE_ERRORS_TO_LOG=1

export OF_USE_LZ4_COMPRESSION=true

# Debugging
## export FOX_RESET_SETTINGS=0
## export FOX_INSTALLER_DEBUG_MODE=1

F=$(find "device" -name "P661N")
	# 修改启动画面背景色为#ffffff
	\cp -fp bootable/recovery/gui/theme/portrait_hdpi/splash.xml "$F"/recovery/root/twres/splash.xml
	sed -i 's/background color="#D34E38"/background color="#538db6"/g' "$F"/recovery/root/twres/splash.xml
	sed -i 's/fill color="#FF8038"/fill color="#538db6"/g' "$F"/recovery/root/twres/splash.xml
    sed -i 's/OrangeFox/Kamchoyun/g' "$F"/recovery/root/twres/splash.xml
	sed -i 's/font resource="of" color="#ffffff"/font resource="of" color="#538db6"/g' "$F"/recovery/root/twres/splash.xml
	sed -i 's/font resource="recovery" color="#ffffff"/font resource="recovery" color="#538db6"/g' "$F"/recovery/root/twres/splash.xml
	
	echo -e "\x1b[96matom: 当你看到这个消息的时候，所有的OrangeFox Var已经添加完毕！\x1b[m"
	
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

export LC_ALL="C.UTF-8"
	export ALLOW_MISSING_DEPENDENCIES=true

#OTA
	export FOX_AB_DEVICE=1
	export FOX_VIRTUAL_AB_DEVICE=1
	export OF_SUPPORT_VBMETA_AVB2_PATCHING=1

device_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_root="$(cd "${device_dir}/../../.." && pwd)"
patch_files=(
	"${device_dir}/patches/0001-Add-regulator-vibrator-haptics-support.patch"
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
