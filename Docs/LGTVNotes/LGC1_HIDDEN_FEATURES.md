# LG C1 Hidden Features

A field guide to every useful menu, overlay, and toggle that is hidden from the standard Settings UI but still reachable with the stock LG Magic Remote (no service remote required). Tested on webOS 6 running firmware 03.53.31 through 03.53.45.

## Quick Reference

| Input sequence or path                                                   | Feature                          | Why you would open it                                                                                    |
| ------------------------------------------------------------------------ | -------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Long-press `Settings` (gear)                                             | Quick Settings ribbon            | Toggle picture, sound, and game optimizer presets without leaving full-screen video.                     |
| Long-press `0`                                                           | Quick Access palette             | Map any app, HDMI input, or device connector macro to number keys 1-9 for one-press launch.              |
| Press `green` button `10x`                                                 | VRR Info overlay                 | Confirm the live frame rate, VRR status, and active resolution while gaming.                             |
| Long-press `Input`                                                       | Home Dashboard                   | Jump to device list, AirPlay controls, and network status without the Home UI clutter.                   |
| Press `mute` button `3x`                                                   | Installation (InStart Lite) menu | Disable no-signal artwork, hide the LG boot logo, run self-diagnostics, or toggle the new screensavers.  |
| Hold `Settings` until men dissappears, release, then enter `1105` + `OK` | Advanced / Hotel menu            | Configure Public Display, USB cloning, IP control, and Set ID parameters normally hidden from consumers. |

## Hidden overlays and menus

### Quick Settings ribbon
Hold the `Settings` (gear) button for roughly two seconds to drop a vertical ribbon over the right edge of the screen. Use the directional pad to reorder cards (Picture, Sound, Game Optimizer, Accessibility) and press the `...` button to expose contextual tips. Long-pressing `Settings` again closes the ribbon immediately.

### Quick Access palette
Long-press `0` to open the Quick Access palette, then highlight any empty slot and press a number 1-9 to store the current app, HDMI input, Home Dashboard card, or automation scene. To replace an assignment, open the palette, focus the slot, press and hold the target number again, then confirm. Firmware 03.53.45 currently replays a reminder toast for each bound slot on boot; unbinding and reassigning clears the pop-up for most users.[^quick-access-bug]

![Quick Access palette](images/QuickAccess.png)
![Quick Access help overlay](images/QuickAccessHelp.png)

### VRR Info overlay
While on an HDMI input that advertises VRR, press the green (A) button ten times rapidly. A small diagnostic box appears in one corner and shows frame rate, VRR lock, bit depth, and the HDMI FRL status. Press the green button once more to dismiss it. The overlay is read-only; use it with consoles or PCs to confirm AMD FreeSync, Nvidia G-Sync Compatible, or 120 Hz output is behaving.

![VRR info overlay](images/VRRInfo.png)

### Home Dashboard shortcut
Long-press the `Input` button to open the Home Dashboard without first loading the entire Home launcher. From here you can:

- Inspect wired and wireless network status and run an internet quick test.
- Reach AirPlay even if the Home bar icons disappeared after an update.[^airplay]
- Reorder HDMI inputs so Quick Access slots stay predictable across firmware resets.

### Mute-button Installation menu
Switch to an HDMI source with an active signal, then press `mute` three times quickly. This pops the installer menu LG intends for pro integrators. Key toggles include:

- `No Signal Image`: Disables the picture-frame screensaver that appears after about two minutes of idle video.[^screensaver]
- `Show LG Logo when turning the set on`: Hides the boot splash for faster, cleaner startups.
- `Screen Saver`: Lets you pick any of the legacy art packs; firmware 03.53.31 removed the Fireworks animation, so choosing "Photo" or "None" is the easiest way to avoid the replacement slideshow.[^fireworks]
- `Self Diagnosis`: Runs HDMI handshake checks and resets CEC (Simplink) without a full reboot.

Use the back button to exit; the TV remembers your choices immediately.

![Mute-menu toggles](https://i.imgur.com/NvoUx5v.jpg)

### Advanced / Hotel menu (Installer Option)
If you need deeper options but still want to avoid a service remote, hold the `Settings` button until a tiny floating icon appears, release, then quickly type `1105` followed by `OK`. The Advanced menu includes:

- **Public Display Settings**: hard caps for volume, channel ranges, button lockouts, and power-on defaults. Useful if the C1 doubles as a shared conference display.
- **Password Change**: set a lock code to keep others out of the installer tree.
- **USB Cloning**: export or import the entire configuration to a thumb drive for backups.
- **Set ID Setup**: assign a display ID so serial or IP control software (including [LGTVControllerCLI](../LGTVControllerCLI)) can target a single panel.
- **IP Control Setup**: confirm wired or wireless MAC addresses, test Wake on LAN, and grant permission to pairing apps such as lg-tv-control-macos.

![Public Display settings](images/AdvancedPublicDisplaySetting.png)
![IP Control setup](images/AdvancedIPControlSetup.png)

> ⚠️ Hotel mode limits how the LG ThinQ and HomeKit apps can reach the TV. If you automate inputs over IP, document each change before enabling any lockout features so you can roll back quickly.

## Firmware-specific screensaver notes

- Firmware `03.53.31` removes the Fireworks screensaver asset entirely. Users who relied on it for burn-in mitigation now only see the new static art set unless they switch the `Screen Saver` dropdown inside the mute-menu to `Photo` or `None`.[^fireworks]
- Firmware `03.53.45` leaves these options intact but introduces a boot-time toast whenever a Quick Access slot is bound to an HDMI input. If this becomes distracting, open Quick Access, clear the slot, reboot, then reassign. This silences the reminder for most people.[^quick-access-bug]
- Neither update touches the installer-menu toggles, so disabling `No Signal Image` still works post-update. Double-check the setting after every firmware flash because LG has been known to revert it to the default ON state.[^screensaver]

## When you actually need the service remote
This document intentionally sticks to features you can reach with the stock remote. Items such as TPC or GSR disablement and white-balance service adjustments still require a true service remote or software like ColorControl. See [LGOLED.md](LGOLED.md#service-remote) for precautions before venturing into that territory.

## Related automation and tooling
Once the hidden menus are dialed in, you can script repeatable control flows:

- [LGTVControllerCLI](../LGTVControllerCLI) offers terminal commands for most Installer and Quick Access actions.
- [LGWebOSRemote](https://github.com/klattimer/LGWebOSRemote) plus [lg-tv-control-macos](https://github.com/cmer/lg-tv-control-macos/) automate wake, sleep, and HDMI switching, replacing many Quick Access bindings with macOS events.
- [MonitorControl](https://github.com/MonitorControl/MonitorControl) mirrors the Quick Settings brightness slider directly on macOS keyboards while honoring whatever limits you set inside the Public Display page.

## References

- [How to change the LG C1 no-signal screensaver (mute-menu walkthrough)](https://www.reddit.com/r/LGOLED/comments/u6mxpo/how_to_change_screensaver_on_lg_oled_c1/j75on8d/)
- [03.53.31 update discussion (Fireworks screensaver removed)](https://www.reddit.com/r/LGOLED/comments/1ne25m7/comment/nfd0lsg/)
- [03.53.45 update thread (Quick Access toast after boot and workaround)](https://www.reddit.com/r/LGOLED/comments/1nu7212/comment/nh07k4e/)
- [AirPlay still available through the Home Dashboard shortcut](https://www.reddit.com/r/LGOLED/comments/1nu7212/comment/nh1v348/)

[^screensaver]: Toggle lives inside the mute-menu (`mute` pressed three times) and affects both the motion artwork and the "picture frame" placeholder after idle HDMI signals.
[^fireworks]: Reported by multiple owners immediately after applying firmware 03.53.31; LG has not provided an official download for the legacy Fireworks animation.
[^quick-access-bug]: Firmware 03.53.45 broadcasts a reminder toast for every bound Quick Access slot during boot. Clearing and reassigning the slot suppresses the pop-up for most people; expect LG to patch this in a future maintenance release.
[^airplay]: Even when the Home launcher hides AirPlay after an update, the long-press `Input` shortcut exposes it in the Home Dashboard device list.
