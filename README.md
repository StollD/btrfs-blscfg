# btrfs-blscfg

This is a simple script + systemd path unit, that generates [blscfg](https://systemd.io/BOOT_LOADER_SPECIFICATION)
entries for every btrfs snapshot that was found on the system.

The advantage of using the bootloader spec is, that you can modify the entries
by simply adding or removing their files. You don't need to write complicated
grub scripts, and regenerate the grub.cfg every time you take a snapshot.

The disadvantage is, that you need a bootloader that supports the bootloader
spec. Currently, only systemd-boot, and grub2 + redhat patches support it.

This script is heavily tailored towards Fedora + snapper, but it is so simple
that it should be easy to adapt it to your distro / snapshot manager of choice.
