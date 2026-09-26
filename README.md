# KBT KPM Repository

This static repository contains one KPM v2 package for jailbroken Kindles:

- `bluetooth-keymap-toggle`: one-tap Bluetooth HID and key-mapping control.

Install Kindle HID Passthrough with Button Mapper before using this add-on. The
HID package may already have been installed manually, so KBT deliberately does
not ask KPM to resolve it as a package dependency.

## Publish

Upload this directory unchanged to any HTTPS static host. For GitHub, commit the
directory to a repository and use the raw URL of `manifest.json`.

Because Kindle search may reject URL punctuation, add the repository once from
kTerm or another Scriptlet:

```sh
/var/local/kmc/bin/kpm add-repo "https://raw.githubusercontent.com/OWNER/REPOSITORY/main/manifest.json"
```

Then install from the Kindle search bar:

```text
;kpm update
;kpm install bluetooth-keymap-toggle
```

After installation, the library contains `Bluetooth + Key Mapping`.

## Remove

```text
;kpm uninstall bluetooth-keymap-toggle
```

The Bluetooth package stops the HID and key-mapping processes on uninstall.

`SHA256SUMS` contains the package checksum.
