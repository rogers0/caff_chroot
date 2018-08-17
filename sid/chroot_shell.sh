#!/bin/sh

SCRIPT_ROOT=$(readlink -f $(dirname $0))
SRC_ROOT=$(readlink -f $(dirname $0)/..)
ARG=$1

. $SCRIPT_ROOT/config_common
[ -e "$SCRIPT_ROOT/config" ] && . $SCRIPT_ROOT/config
[ -e "$SCRIPT_ROOT/config_local" ] && . $SCRIPT_ROOT/config_local
LOCAL_HOME=$(eval echo ~$(id -nu $LOCAL_UID 2>/dev/null))

if [ $LOCAL_UID -eq 0 -a -d $CHROOT ]; then
# chroot and su to the specific normal user
	grep $CHROOT/dev /proc/mounts > /dev/null || mount --bind /dev $CHROOT/dev
	grep $CHROOT/proc /proc/mounts > /dev/null || chroot $CHROOT mount -t proc proc /proc
	grep $CHROOT/sys /proc/mounts > /dev/null || chroot $CHROOT mount -t sysfs sysfs /sys
	grep $CHROOT/dev/pts /proc/mounts > /dev/null || chroot $CHROOT mount -t devpts devpts /dev/pts

	BASENAME=$(basename $SRC_ROOT)
	mkdir -p $CHROOT/$NORMALUSER/$BASENAME
	grep "$CHROOT/$NORMALUSER/$BASENAME" /proc/mounts > /dev/null ||
		mount --bind $SRC_ROOT $CHROOT/$NORMALUSER/$BASENAME

	if [ -e "$CHROOT$CHROOT_COUNT" ]; then
		count=$(cat $CHROOT$CHROOT_COUNT)
		sed -i s/$count/$(($count+1))/ $CHROOT$CHROOT_COUNT
	else
		echo 1 > $CHROOT$CHROOT_COUNT
	fi
	echo chroot count=$(cat $CHROOT$CHROOT_COUNT)

	case "$ARG" in
	prepare)
		exit 0
		;;
	root)
		echo Start to work under chroot shell with root privilege!
		echo chroot $CHROOT
		chroot $CHROOT
		;;
	*)
		echo Start to work under chroot shell
		echo chroot $CHROOT su -l $NORMALUSER
		chroot $CHROOT su -l $NORMALUSER
	esac
	#echo you need to run \"./umount_chroot_device.sh\" to release some chrooted device mounting after finishing all chroot shells.
	$SCRIPT_ROOT/umount_chroot_device.sh
fi
