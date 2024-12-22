#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing $scriptpath/$relativepath); fi

# Abort on Error
set -e

# Load Configuration
source "${toolpath}/config.sh"

# Install Requirements
apt-get install acpica-tools

# Create Folder if not existing yet
mkdir -p "${acpi_working_folder}"

# Change Current Working Directory
cd "${acpi_working_folder}" || exit

# Create Folder Structure to later generate uncompressed CPIO Archive
mkdir -p kernel/firmware/acpi

# Extract the Machine ACPI Tables
acpidump >acpidump
acpixtract -a acpidump

# Execute Single Scripts
if [[ "${disassemble_all}" == "yes" ]]
then
    # Disassemble all Tables
    iasl -d *.dat
fi

