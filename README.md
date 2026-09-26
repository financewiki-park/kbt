# KBT KPM Repository

This static repository contains one KPM v2 package for jailbroken Kindles:

- `bluetooth-keymap-toggle`: one-tap Bluetooth HID and key-mapping control.

Install or register the repository that supplies `kindle-hid-passthrough`
before installing this add-on.

## Publish

Upload this directory unchanged to any HTTPS static host. For GitHub, commit the
directory to a repository and use the raw URL of `manifest.v2.json`.

Because Kindle search may reject URL punctuation, add the repository once from
kTerm or another Scriptlet:

```sh
/var/local/kmc/bin/kpm add-repo "https://raw.githubusercontent.com/OWNER/REPOSITORY/main/manifest.v2.json"
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

`SHA256SUMS` contains checksums for the two package artifacts and repository
manifests.
