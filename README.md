# acpi-linux-patching
Some Scripts to Patch ACPI Issues (mainly FADT for ASPM Support)

This is needed in case you get a Message like this in `dmesg`:
```
ACPI FADT declares the system doesn't support PCIe ASPM, so disable
```

# Important
Note that, if you change something in BIOS **AFTER** you setup these Custom ACPI Tables, you might experience Boot Failure / Boot Hanging at around 0s with an ACPI Message.

To bypass this, in GRUB2, press `e`, go to the `initrd` Line, remove the offending `/initrd_acpi_patched` on that Line (make sure to leave the "Real" InitramFS Image !), then press `F10` to Continue.

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
