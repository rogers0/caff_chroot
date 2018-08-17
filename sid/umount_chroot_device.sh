#!/bin/sh

SCRIPT_ROOT=$(readlink -f $(dirname $0))
SRC_ROOT=$(readlink -f $(dirname $0)/..)

. $SCRIPT_ROOT/config_common
[ -e "$SCRIPT_ROOT/config" ] && . $SCRIPT_ROOT/config
[ -e "$SCRIPT_ROOT/config_local" ] && . $SCRIPT_ROOT/config_local

if [ $LOCAL_UID -eq 0 -a -d $CHROOT ]; then
# chroot and su to the specific normal user

	if [ ! -e $CHROOT$CHROOT_COUNT ]; then
		echo Error: no chroot counting file: $CHROOT$CHROOT_COUNT
		exit 1
	fi

	count=$(cat $CHROOT$CHROOT_COUNT)
	if [ $count -gt 1 ]; then
		sed -i s/$count/$(($count-1))/ $CHROOT$CHROOT_COUNT
		echo chroot count=$(cat $CHROOT$CHROOT_COUNT)
		exit 0
	fi
	echo chroot count=$(($count-1)), umount all path within chroot environment
	rm $CHROOT$CHROOT_COUNT

	BASENAME=$(basename $SRC_ROOT)
	grep "$CHROOT/$NORMALUSER/$BASENAME" /proc/mounts > /dev/null && umount $CHROOT/$NORMALUSER/$BASENAME
	grep $CHROOT/dev/pts /proc/mounts > /dev/null && umount $CHROOT/dev/pts
	grep $CHROOT/sys /proc/mounts > /dev/null && umount $CHROOT/sys
	grep $CHROOT/proc /proc/mounts > /dev/null && umount $CHROOT/proc
	grep $CHROOT/dev /proc/mounts > /dev/null && umount $CHROOT/dev
fi
