# LG C1 Hidden Features

A field guide to every useful menu, overlay, and toggle that is hidden from the standard Settings UI but still reachable with the stock LG Magic Remote (no service remote required). Tested on webOS 6 running firmware 03.53.31 through 03.53.45.

## Quick Reference

| Feature                          | Why you would open it                                                                                    | Input sequence or path                       | Details                                                         |
| -------------------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------- | --------------------------------------------------------------- |
| Quick Settings ribbon            | Toggle picture, sound, and game optimizer presets without leaving full-screen video.                     | Long-press `Settings` (gear)                 | [Quick Settings ribbon](#quick-settings-ribbon)                 |
| Quick Access palette             | Map any app, HDMI input, or device connector macro to number keys 1-9 for one-press launch.              | Long-press `0`                               | [Quick Access palette](#quick-access-palette)                   |
| VRR Info overlay                 | Confirm the live frame rate, VRR status, and active resolution while gaming.                             | Press `green` button `10x`                   | [VRR Info overlay](#vrr-info-overlay)                           |
| Home Dashboard                   | Jump to device list, AirPlay controls, and network status without the Home UI clutter.                   | Long-press `Input`                           | [Home Dashboard shortcut](#home-dashboard-shortcut)             |
| Installation (InStart Lite) menu | Disable no-signal artwork[^screensaver], hide the LG boot logo, run self-diagnostics, or toggle the new screensavers.[^fireworks] | Press `mute` button `3x`                     | [Mute-button Installation menu](#mute-button-installation-menu) |
| Advanced / Hotel menu            | Configure Public Display, USB cloning, IP control, and Set ID parameters normally hidden from consumers. | Hold `Settings` until UI gone, `1105` + `OK` | [Advanced / Hotel menu](#advanced--hotel-menu-installer-option) |

## Quick Reference (html)

<table>
  <thead>
		<tr>
			<th>Feature</th>
			<th>Why you would open it</th>
			<th>Input sequence or path</th>
			<th>Details</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Quick Settings ribbon</td>
			<td>Toggle picture, sound, and game optimizer presets without leaving full-screen video.</td>
			<td>Long-press <code>Settings</code> (gear)</td>
			<td><a href="#quick-settings-ribbon">Quick Settings ribbon</a></td>
		</tr>
		<tr>
			<td>Quick Access palette</td>
			<td>Map any app, HDMI input, or device connector macro to number keys 1-9 for one-press launch.</td>
			<td>Long-press <code>0</code></td>
			<td><a href="#quick-access-palette">Quick Access palette</a></td>
		</tr>
		<tr>
			<td>VRR Info overlay</td>
			<td>Confirm the live frame rate, VRR status, and active resolution while gaming.</td>
			<td>Press <code>green</code> button <code>10x</code></td>
			<td><a href="#vrr-info-overlay">VRR Info overlay</a></td>
		</tr>
		<tr>
			<td>Home Dashboard</td>
			<td>Jump to device list, AirPlay controls, and network status without the Home UI clutter.</td>
			<td>Long-press <code>Input</code></td>
			<td><a href="#home-dashboard-shortcut">Home Dashboard shortcut</a></td>
		</tr>
		<tr>
			<td>Installation (InStart Lite) menu</td>
			<td>Disable no-signal artwork, hide the LG boot logo, run self-diagnostics, or toggle the new screensavers.</td>
			<td>Press <code>mute</code> button <code>3x</code></td>
			<td><a href="#mute-button-installation-menu">Mute-button Installation menu</a></td>
		</tr>
		<tr>
			<td>Advanced / Hotel menu</td>
			<td>Configure Public Display, USB cloning, IP control, and Set ID parameters normally hidden from consumers.</td>
			<td>Hold <code>Settings</code> until UI gone, then enter <code>1105</code> + <code>OK</code></td>
			<td><a href="#advanced--hotel-menu-installer-option">Advanced / Hotel menu</a></td>
		</tr>
	</tbody>
</table>

*The HTML table mirrors the Markdown version above; see footnotes such as [^screensaver] and [^fireworks] for cited installer-menu behavior.*

## Hidden overlays and menus

### Quick Settings ribbon
Hold the `Settings` (gear) button for roughly two seconds to drop a vertical ribbon over the right edge of the screen. Use the directional pad to reorder cards (Picture, Sound, Game Optimizer, Accessibility) and press the `...` button to expose contextual tips. Long-pressing `Settings` again closes the ribbon immediately.

<a href="https://imgur.com/a/Tenbvqn" target="_blank" rel="noopener">See the LG C1 Quick Settings album for a full walkthrough.</a>

### Quick Access palette
Long-press `0` to open the Quick Access palette, then highlight any empty slot and press a number 1-9 to store the current app, HDMI input, Home Dashboard card, or automation scene. To replace an assignment, open the palette, focus the slot, press and hold the target number again, then confirm. Firmware 03.53.45 currently replays a reminder toast for each bound slot on boot; unbinding and reassigning clears the pop-up for most users.[^quick-access-bug]

<img src="images/QuickAccess.png" alt="Quick Access palette" width="500" />
<img src="images/QuickAccessHelp.png" alt="Quick Access help overlay" width="500" />

### VRR Info overlay
While on an HDMI input that advertises VRR, press the green (A) button ten times rapidly. A small diagnostic box appears in one corner and shows frame rate, VRR lock, bit depth, and the HDMI FRL status. Press the green button once more to dismiss it. The overlay is read-only; use it with consoles or PCs to confirm AMD FreeSync, Nvidia G-Sync Compatible, or 120 Hz output is behaving.

<img src="images/VRRInfo.png" alt="VRR info overlay" width="500" />
<img src="https://i.imgur.com/K3Nj4fL.jpg" alt="LG C1 VRR overlay" width="500" />

### Home Dashboard shortcut
Long-press the `Input` button to open the Home Dashboard without first loading the entire Home launcher. From here you can:

- Inspect wired and wireless network status and run an internet quick test.
- Reach AirPlay even if the Home bar icons disappeared after an update.[^airplay]
- Reorder HDMI inputs so Quick Access slots stay predictable across firmware resets.

### Mute-button Installation menu
Switch to an HDMI source with an active signal, then press `mute` three times quickly. This pops the installer menu LG intends for pro integrators. Key toggles include:

- `No Signal Image`: Disables the picture-frame screensaver that appears after about two minutes of idle video.[^screensaver]
- `Show LG Logo when turning the set on`: Hides the boot splash for faster, cleaner startups.
- `Screen Saver`: Lets you pick any of the legacy art packs; firmware 03.53.31 removed the Fireworks animation, so choosing "Photo" or "None" is the easiest way to avoid the replacement slideshow.[^fireworks] The [Disable the "No Signal" screensaver album](https://imgur.com/a/iLuu1qh) shows each toggle.
- `Self Diagnosis`: Runs HDMI handshake checks and resets CEC (Simplink) without a full reboot.

Use the back button to exit; the TV remembers your choices immediately.

<img src="https://i.imgur.com/NvoUx5v.jpg" alt="Mute-menu toggles" width="500" />

### Advanced / Hotel menu (Installer Option)
If you need deeper options but still want to avoid a service remote, hold the `Settings` button until a tiny floating icon appears, release, then quickly type `1105` followed by `OK`. The Advanced menu includes:

- **Public Display Settings**: hard caps for volume, channel ranges, button lockouts, and power-on defaults. Useful if the C1 doubles as a shared conference display.
- **Password Change**: set a lock code to keep others out of the installer tree.
- **USB Cloning**: export or import the entire configuration to a thumb drive for backups.
- **Set ID Setup**: assign a display ID so serial or IP control software (including [LGTVControllerCLI](../LGTVControllerCLI)) can target a single panel.
- **IP Control Setup**: confirm wired or wireless MAC addresses, test Wake on LAN, and grant permission to pairing apps such as lg-tv-control-macos.

<img src="images/AdvancedPublicDisplaySetting.png" alt="Public Display settings" width="500" />
<img src="images/AdvancedIPControlSetup.png" alt="IP Control setup" width="500" />
<a href="https://imgur.com/a/W4Hznf8" target="_blank" rel="noopener">Browse the LG C1 hotel/installer menu album for every submenu screenshot.</a>

<details><summary>


* [Imgur I: Qvgn P7 G](https://i.imgur.com/QvgnP7G.jpg)
* [Imgur I: Qvgn P7 G](https://i.imgur.com/QvgnP7G.jpg)
* [Imgur I: Qvgn P7 G](https://i.imgur.com/QvgnP7G.jpg)
* [Imgur I: Qvgn P7 G](https://i.imgur.com/QvgnP7G.jpg)
* [Imgur I: Wwoe6 Sx](https://i.imgur.com/wwoe6SX.jpg)
* [Imgur I: El Xzdtf](https://i.imgur.com/elXZDTF.jpg)
* [Imgur I: D Po714i](https://i.imgur.com/dPO714i.jpg)
* [Imgur I: V Wmgxxp](https://i.imgur.com/vWMGXXp.jpg)


<details open name="requirements"><summary><b>Graduation Requirements</b></summary>

* a
* b
* d

</details>

<details name="requirements">
  <summary>Graduation Requirements</summary>
  <p>
    Requires 40 credits, including a passing grade in health, geography,
    history, economics, and wood shop.
  </p>
</details>
<details name="requirements">
  <summary>System Requirements</summary>
  <p>
    Requires a computer running an operating system. The computer must have some
    memory and ideally some kind of long-term storage. An input device as well
    as some form of output device is recommended.
  </p>
</details>

> ⚠️ Hotel mode limits how the LG ThinQ and HomeKit apps can reach the gsTV. If you automate inputs over IP, document each change before enabling any lockout features so you can roll back quickly.

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
- [MonitorControl](https://github.com/MonitorControl/MonitorControl) mirrors the Quick Settings brightness slider directly on macOS keyboards while honoring whatever limits you set inside the Public Display page. See the [resolution picker screenshot](https://i.imgur.com/pkeH9X2.png) and [settings preset album](https://imgur.com/a/b5qxzME) for reference.

- Want more perspectives? Browse the [LG C1 Misc Images album](https://imgur.com/a/7bqrXOv) for alternate menu layouts.

## LGC1 Service Remote

There are plenty of additional configurations available with a `service remote`[^service-remote]

[YouTube: z2k - favs](https://www.youtube.com/playlist?list=PL3jqN2e_0pmmWynsG8MatLz4myMpsfbc6)

# References

- [How to change the LG C1 no-signal screensaver (mute-menu walkthrough)](https://www.reddit.com/r/LGOLED/comments/u6mxpo/how_to_change_screensaver_on_lg_oled_c1/j75on8d/)
- [03.53.31 update discussion (Fireworks screensaver removed)](https://www.reddit.com/r/LGOLED/comments/1ne25m7/comment/nfd0lsg/)
- [03.53.45 update thread (Quick Access toast after boot and workaround)](https://www.reddit.com/r/LGOLED/comments/1nu7212/comment/nh07k4e/)
- [AirPlay still available through the Home Dashboard shortcut](https://www.reddit.com/r/LGOLED/comments/1nu7212/comment/nh1v348/)


## Footnotes

[^screensaver]: Toggle lives inside the mute-menu (`mute` pressed three times) and affects both the motion artwork and the "picture frame" placeholder after idle HDMI signals; documented in [this Reddit walkthrough](https://www.reddit.com/r/LGOLED/comments/u6mxpo/how_to_change_screensaver_on_lg_oled_c1/j75on8d/).
[^fireworks]: Reported by multiple owners immediately after applying firmware 03.53.31; see the discussion in [this Reddit thread](https://www.reddit.com/r/LGOLED/comments/1ne25m7/comment/nfd0lsg/).
[^quick-access-bug]: Firmware 03.53.45 broadcasts a reminder toast for every bound Quick Access slot during boot; workaround noted in [this Reddit comment](https://www.reddit.com/r/LGOLED/comments/1nu7212/comment/nh07k4e/).
[^airplay]: Even when the Home launcher hides AirPlay after an update, the long-press `Input` shortcut exposes it in the Home Dashboard device list per [this Reddit confirmation](https://www.reddit.com/r/LGOLED/comments/1nu7212/comment/nh1v348/).
[^service-remote]: [LG OLED Service Remote - Playlist](https://www.youtube.com/playlist?list=PL3jqN2e_0pmkRimKMFwVVrN0rX2opzqYG)
