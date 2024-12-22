#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing $scriptpath/$relativepath); fi

# Abort on Error
set -e

# Load Configuration
source "${toolpath}/config.sh"

# Load Common Script
source "${toolpath}/init.sh"

# Execute Single Scripts
if [[ "${enable_aspm_patch}" == "yes" ]]
then
    source "${toolpath}/patch_aspm.sh"
fi

# Add the raw ACPI tables to an uncompressed cpio archive.
# They must be put into a /kernel/firmware/acpi directory inside the cpio
# archive. Note that if the table put here matches a platform table
# (similar Table Signature, and similar OEMID, and similar OEM Table ID)
# with a more recent OEM Revision, the platform table will be upgraded by
# this table. If the table put here doesn't match a platform table
# (dissimilar Table Signature, or dissimilar OEMID, or dissimilar OEM Table
# ID), this table will be appended.
mkdir -p kernel/firmware/acpi

# Create Uncompressed cpio Archive with the Patched ACPI Tables
find kernel | cpio -H newc --create > /boot/initrd_acpi_patched

# Create GRUB Configuration
echo 'GRUB_EARLY_INITRD_LINUX_CUSTOM="initrd_acpi_patched"' > /etc/default/grub.d/acpi-tables.cfg

# (Optional) Increase ACPI Debug Level
echo 'GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX} acpi.debug_level=0x2 acpi.debug_layer=0xFFFFFFFF"' >> /etc/default/grub.d/acpi-tables.cfg
echo 'GRUB_CMDLINE_LINUX_DEFAULT="${GRUB_CMDLINE_LINUX_DEFAULT} acpi.debug_level=0x2 acpi.debug_layer=0xFFFFFFFF"' >> /etc/default/grub.d/acpi-tables.cfg

# Update GRUB
update-grub

# Update Initramfs (probably not required)
# update-initramfs -k all -u

# Update GRUB (once more)
update-grub

# Update Initramfs (once more, probably not required)
# update-initramfs -k all -u

