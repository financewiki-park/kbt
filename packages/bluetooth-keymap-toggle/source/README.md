# Bluetooth + Key Mapping Toggle

Installs a Kindle Scriptlet that toggles both `kindle-hid-passthrough` and
`kindle-button-mapper` with one tap.

On first launch, the two Upstart jobs are changed to manual-only startup. Their
original files are saved with the suffix `.bluetooth-toggle.bak`. Uninstalling
the package restores those backups and the original automatic-start behavior.

Requires the Kindle HID Passthrough package, including Button Mapper.
