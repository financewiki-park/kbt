# KBT KPM Repository

This repository contains the KPM package source and standalone feed for:

- `bluetooth-keymap-toggle`: one-tap Bluetooth HID and key-mapping control.

Install Kindle HID Passthrough with Button Mapper before using this add-on. The
HID package may already have been installed manually, so KBT deliberately does
not ask KPM to resolve it as a package dependency.

## Install

Use the canonical `kindle-lab` KPM hub:

```sh
/var/local/kmc/bin/kpm add-repo "https://raw.githubusercontent.com/kindle-lab/kpm-repo/main/manifest.json"
/var/local/kmc/bin/kpm update
/var/local/kmc/bin/kpm install bluetooth-keymap-toggle
```

After installation, the library contains `Bluetooth + Key Mapping`.

## Standalone feed

The repository-local `manifest.json` remains available for development and
standalone validation, but the public installation entry point is
`kindle-lab/kpm-repo`.

## Remove

```text
;kpm uninstall bluetooth-keymap-toggle
```

The Bluetooth package stops the HID and key-mapping processes on uninstall.

`SHA256SUMS` contains the package checksum.
