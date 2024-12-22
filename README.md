# acpi-linux-patching
Some Scripts to Patch ACPI Issues (mainly FADT for ASPM Support)

# Setup
Clone Repository:
```
git clone https://github.com/luckylinux/acpi-linux-patching.git
```

Change into the Scripts Folder
```
cd acpi-linux-patching
```

Create Configuration File based on Example File:
```
cp config.sh.example config.sh
```

# Patching ACPI Tables
Run Script:
```
./patch.sh
```

Reboot:
```
reboot
```

Check that ACPI Tables have successfully been patched:
```
dmesg | grep -i acpi | grep -i override
```

# References
- https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html
- https://docs.kernel.org/admin-guide/acpi/initrd_table_override.html
- https://gist.github.com/lamperez/d5b385bc0c0c04928211e297a69f32d7
- https://z8.re/blog/aspm.html
