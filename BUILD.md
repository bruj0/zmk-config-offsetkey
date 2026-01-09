# ZMK Firmware Build Guide

This document describes how to build the ZMK firmware for the Offsetkey keyboard.

## Prerequisites

- Docker installed and running
- VS Code with Dev Containers extension
- The ZMK workspace directory at `../zmk-workspace` (sibling to this repo)

## Development Container Setup

1. Open this repository in VS Code
2. When prompted, click "Reopen in Container" or use Command Palette: `Dev Containers: Reopen in Container`
3. The container will automatically initialize the ZMK workspace on first run

## Building Firmware

### Environment Setup

The container sets up environment variables automatically. If you need to set them manually:

```bash
export ZEPHYR_BASE=/workspaces/zmk/zephyr
export ZMK_CONFIG=/workspaces/zmk-config/config
```

### Build Commands

All builds are run from the `/workspaces/zmk` directory.

#### Dongle Configuration (Split Keyboard with USB Dongle)

**Peripheral Left (encoder side):**
```bash
cd /workspaces/zmk && west build -d build/peripheral_left -b eyelash_nano \
  -- -DSHIELD=offsetkey_peripheral_left \
  -DZMK_CONFIG=/workspaces/zmk-config/config \
  -DBOARD_ROOT=/workspaces/zmk-config
```

**Peripheral Right:**
```bash
cd /workspaces/zmk && west build -d build/peripheral_right -b eyelash_nano \
  -- -DSHIELD=offsetkey_peripheral_right \
  -DZMK_CONFIG=/workspaces/zmk-config/config \
  -DBOARD_ROOT=/workspaces/zmk-config
```

**Central Dongle (with ZMK Studio):**
```bash
cd /workspaces/zmk && west build -d build/dongle -b eyelash_nano \
  -S studio-rpc-usb-uart \
  -- -DSHIELD=offsetkey_central_dongle \
  -DZMK_CONFIG=/workspaces/zmk-config/config \
  -DBOARD_ROOT=/workspaces/zmk-config \
  -DCONFIG_ZMK_STUDIO=y \
  -DCONFIG_ZMK_STUDIO_LOCKING=n
```

**Settings Reset:**
```bash
cd /workspaces/zmk && west build -d build/reset -b eyelash_nano \
  -- -DSHIELD=settings_reset \
  -DZMK_CONFIG=/workspaces/zmk-config/config \
  -DBOARD_ROOT=/workspaces/zmk-config
```

### Build All Parts

```bash
cd /workspaces/zmk

# Clean previous builds
rm -rf build

# Build all parts
west build -d build/peripheral_left -b eyelash_nano -- -DSHIELD=offsetkey_peripheral_left -DZMK_CONFIG=/workspaces/zmk-config/config -DBOARD_ROOT=/workspaces/zmk-config

west build -d build/peripheral_right -b eyelash_nano -- -DSHIELD=offsetkey_peripheral_right -DZMK_CONFIG=/workspaces/zmk-config/config -DBOARD_ROOT=/workspaces/zmk-config

west build -d build/dongle -b eyelash_nano -S studio-rpc-usb-uart -- -DSHIELD=offsetkey_central_dongle -DZMK_CONFIG=/workspaces/zmk-config/config -DBOARD_ROOT=/workspaces/zmk-config -DCONFIG_ZMK_STUDIO=y -DCONFIG_ZMK_STUDIO_LOCKING=n

west build -d build/reset -b eyelash_nano -- -DSHIELD=settings_reset -DZMK_CONFIG=/workspaces/zmk-config/config -DBOARD_ROOT=/workspaces/zmk-config
```

## Firmware Files

After building, firmware files are located at:

| Part | Location |
|------|----------|
| Peripheral Left | `/workspaces/zmk/build/peripheral_left/zephyr/zmk.uf2` |
| Peripheral Right | `/workspaces/zmk/build/peripheral_right/zephyr/zmk.uf2` |
| Dongle | `/workspaces/zmk/build/dongle/zephyr/zmk.uf2` |
| Settings Reset | `/workspaces/zmk/build/reset/zephyr/zmk.uf2` |

These are also accessible on the host at `../zmk-workspace/build/*/zephyr/zmk.uf2`

## Flashing

1. Put the keyboard/dongle into bootloader mode (double-tap reset button)
2. A USB drive will appear (e.g., `NICENANO`)
3. Copy the appropriate `.uf2` file to the drive
4. The device will automatically reboot with new firmware

## Key Build Parameters

| Parameter | Description |
|-----------|-------------|
| `-b eyelash_nano` | Target board |
| `-DSHIELD=<shield>` | Shield configuration |
| `-DZMK_CONFIG=<path>` | Path to config directory |
| `-DBOARD_ROOT=<path>` | Additional board/shield search path |
| `-S studio-rpc-usb-uart` | Enable ZMK Studio snippet |
| `-DCONFIG_ZMK_STUDIO=y` | Enable ZMK Studio |
| `-DCONFIG_ZMK_STUDIO_LOCKING=n` | Disable Studio locking |

## Troubleshooting

### Shield Not Found
Add `-DBOARD_ROOT=/workspaces/zmk-config` to include local shields.

### Zephyr Not Found
Ensure `ZEPHYR_BASE` is set: `export ZEPHYR_BASE=/workspaces/zmk/zephyr`

### West Modules Out of Date
Run `west update` from `/workspaces/zmk` directory.

### USB Logging (Debug)
Enable in `config/offsetkey.conf`:
```
CONFIG_ZMK_USB_LOGGING=y
```

On macOS, use `screen` to view logs:
```bash
screen /dev/tty.usbmodem* 115200
```

## ZMK Studio

ZMK Studio allows runtime keymap configuration. Access it at:
https://zmk.studio

The dongle is built with Studio support enabled.

## Encoder Configuration

The encoder on the left peripheral supports:
- **Base layer**: Mouse scroll wheel (up/down)
- **Layer 1**: Arrow keys (up/down)
- **Layer 2**: Volume control

Configured in `config/offsetkey.keymap` using `sensor-bindings`.

