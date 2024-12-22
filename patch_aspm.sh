#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing $scriptpath/$relativepath); fi

# Abort on Error
set -e

# Load Configuration
source "${toolpath}/config.sh"

# Load Common Scripts
source "${toolpath}/init.sh"

# Extract the Machine ACPI Tables
# acpidump >acpidump
# acpixtract -a acpidump

# Disassemble the ACPI Tables
iasl -d facp.dat

# Get Current Oem Revision
current_oem_revision=$(cat "facp.dsl" | grep "Oem Revision" | sed -E "s|.*\s([0-9]+)$|\1|")

# Increase Oem Revision by 1
new_oem_revision=$(echo "${current_oem_revision}+1" | bc)

# Replace in-place
sed -Ei "s|^(.*?)Oem Revision(\s*?):(\s*?)([0-9]+)$|\1Oem Revision\2:\3${new_oem_revision}|" "facp.dsl"

# Force ASPM to be Enabled
sed -Ei "s|(\s*?)PCIe ASPM Not Supported \(V4\) : 1|\1PCIe ASPM Not Supported \(V4\) : 0|" "facp.dsl"

# Add the raw ACPI tables to an uncompressed cpio archive.
# They must be put into a /kernel/firmware/acpi directory inside the cpio
# archive. Note that if the table put here matches a platform table
# (similar Table Signature, and similar OEMID, and similar OEM Table ID)
# with a more recent OEM Revision, the platform table will be upgraded by
# this table. If the table put here doesn't match a platform table
# (dissimilar Table Signature, or dissimilar OEMID, or dissimilar OEM Table
# ID), this table will be appended.
mkdir -p kernel/firmware/acpi



find kernel | cpio -H newc --create > /boot


# Change Working Directory back to where we were
cd "${toolpath}" || exit
