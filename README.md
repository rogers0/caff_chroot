# caff-chroot
Sign GPG key in chroot sid environment.


----
Purpose
----

To make a chroot environment especially for key signing under Debian.
Currently working for Debian Sid.


----
Howto
----

Step0, make a chroot environment. The script will debootstrap a minimal rootfs.

	$ sudo ./0_mkchroot.sh

Step1, get source code from Debian Kernel SCM. You could either choose to run this out-of or within chroot

	$ sudo ./chroot_shell.sh
	## Below is under chroot environment
	$ caff 0x1234567890ABCDEF

Step2 (Optional), you can maintain this chroot easily.

	$ sudo ./apt-update.sh

	or

	$ sudo ./chroot_shell.sh root
	## Below is under chroot environment with root previlege
	# apt update

----
Credit
----

- https://kernel-handbook.debian.net
