
<H1>Table of Contents</H1>
- [Settings](#settings)
- [Hidden Menus](#hidden-menus)
  - [VRR Info](#vrr-info)
  - [Quick Settings](#quick-settings)
  - [Quick Access](#quick-access)
  - [Mute Button Menu](#mute-button-menu)
    - [Disable the "No Signal" Screensaver (image of a picture frame)](#disable-the-no-signal-screensaver-image-of-a-picture-frame)
    - [Disable the LG Logo at Startup](#disable-the-lg-logo-at-startup)
  - [Advanced Settings / Hotel Menu](#advanced-settings--hotel-menu)
    - [Warning TODO](#warning-todo)
  - [Service Remote](#service-remote)
    - [Dictionary / Terms / Abbreviations](#dictionary--terms--abbreviations)
  - [DisplayMenu (app)](#displaymenu-app)
  - [External Display for macOS](#external-display-for-macos)
    - [Hammerspoon](#hammerspoon)
    - [MonitorControl](#monitorcontrol)
    - [LGWebOSRemote + Hammerspoon](#lgwebosremote--hammerspoon)
  - [Disable `TPC`](#disable-tpc)
  - [Abbreviations for the curious:](#abbreviations-for-the-curious)


# Settings

* [Imgur (LG C1 Hotel Menu)](https://imgur.com/a/W4Hznf8)

* [Imgur (How to disable the "No Signal" screensaver on an LGC1 OLED TV)](https://imgur.com/a/iLuu1qh)

* [Imgur (LG C1 Misc Images)](https://imgur.com/a/7bqrXOv) 

# Hidden Menus

## VRR Info
* Press the `green` button 10 times rapidly. An overlay window will appear in 1 of the 4 corners to display live framerate and resolution.
* [Imgur (LG C1 VRR Overlay)](https://i.imgur.com/K3Nj4fL.jpg)

## Quick Settings
A general guide about the quick settings menu
* [Imgur (LG C1 Quick Settings)](https://imgur.com/a/Tenbvqn)


## Quick Access
You can assign certain functions to a long press gesture on any of the number keys (1-9). There are multiple ways to configure this:
* Long press '0' to bring up Quick Access menu

* [Imgur (LG C1 Quick Access)](https://i.imgur.com/UggSgeF.jpg)
* [Imgur (LG C1 Quick Access Help)](https://i.imgur.com/MuUImNO.jpg)


## Mute Button Menu
* Select an `HDMI` input which has a signal. 
* Press the `mute` button 3 times.
* [Imgur (3x mute menu)](https://i.imgur.com/NvoUx5v.jpg)

This hidden menu has a few different submenus and lets you do things like: 

### Disable the "No Signal" Screensaver (image of a picture frame)
* Bring up the [Mute Button Menu](#mute-button-menu)
* Disable the toggle titled `No Signal Image` as pictured here ([Imgur (How to disable the "No Signal" screensaver on an LGC1 OLED TV)](https://imgur.com/a/iLuu1qh))
* [Reddit post](https://www.reddit.com/r/LGOLED/comments/u6mxpo/how_to_change_screensaver_on_lg_oled_c1/j75on8d/)


### Disable the LG Logo at Startup
* Bring up the [Mute Button Menu](#mute-button-menu)
* Disable the toggle titled `Show LG Logo when turnin...` as pictured here ([Imgur (How to disable the "No Signal" screensaver on an LGC1 OLED TV)](https://imgur.com/a/iLuu1qh))


## Advanced Settings / Hotel Menu
This is a pretty big menu hierarchy. The top level items:
* Public Display Settings: Limit channels, volume, controls, etc...
* Password Change: Use a password for use in public areas. 
* USB Utilities: Import/Export from USB drive
* Set ID Setup (TV's ID): Change the TV's ID
* IP Control Setup: View mac addresses, network conditions, remote access permissions, etc...

### Warning TODO
* [ ] detail the problems with HomeKit and LG App when this mode is enabled


* [Reddit post](https://www.reddit.com/r/OLED/comments/zuinu3/can_you_put_lg_c1_into_hotel_mode/jdj66a9/)
* [Imgur Post](https://imgur.com/a/W4Hznf8)



## Service Remote
### Dictionary / Terms / Abbreviations
* `ABL`: `Auto Brightness Limiter`
* `ABSL`: `Auto Brightness Static Limiter`
* `TPC`: In LG TVs, `ASBL` is known as Temporal Peak Luminance Control (`TPC`). [[Reference](https://techprofet.com/lg-tv-auto-dimming/)]
* `GSR`: Global Sticky Reduction (GSR). This feature is designed to detect small parts of a static image and dim those areas a bit. It is the technology behind logo protection feature in many LG OLED TVs. [[Reference](https://techprofet.com/lg-tv-auto-dimming/)]

## DisplayMenu (app)
* [link](http://displaymenu.milchimgemuesefach.de/features.html)

## External Display for macOS
This section allows you to use your LGC1 as an external display for macOS. 
* Screen sleeps when expected
* Screen wakes when expected (move the mouse, unlock w/fingerprint reader, etc...)
* Brightness keys on keyboard work to control the TV brightness. 
* Volume keys on keyboard work to control the TV's volume (when hooked up via HDMI port, not USB-c). 

* [Reddit post](https://www.reddit.com/r/OLED_Gaming/comments/wc9ids/steps_to_make_lg_c2_a_monitor_for_the_mac/j79krqi/)
* [See LGTV hammerspoon script](/Users/zakkhoyt/.hammerspoon/init.lua)  
`source ~/opt/lgtv/bin/activate`


### Hammerspoon
```
When both the dock icon and menu icon
are disabled, you can get back to this
Preferences window by activating
Hammerspoon from Spotlight or by
running 'open -a Hammerspoon' from
Terminal, and then pressing Command +
Comma.
```


--- 
Great post! Super helpful to get me on my way to using my MacBookPro (M1Max) with my LG C1. I did encounter a couple of bumps along the way and also found that there are with some newer/better tools.

### [MonitorControl](https://github.com/MonitorControl/MonitorControl) 
I got this to:
* Control my TV's brightness with my keyboard. 
* Control my TV's volume/mute with my mac keyboard.
    * Those of you with Apple Silicon Macs (M1, M2, etc...) HDMI connection to your TV (Not USB-c), you will find that you cannot control the volume of your HDMI device. This is a hardware limitation that you can read abou [here](https://github.com/MonitorControl/MonitorControl/discussions/837#discussioncomment-1880153). The simplest workaround that I found was to install [proxy-audio-device)](https://github.com/briankendall/proxy-audio-device) which is an audio proxy driver.

  ### [LGWebOSRemote + Hammerspoon](https://github.com/cmer/lg-tv-control-macos/)
This will allow you to:
* Automatically wake/sleep and change the input of your LG TV when used as a monitor on macOS. 
* If you are a programmer, send commands to your TV from terminal. Write your own controller logic. 

## Disable `TPC`
I did purchase the service remote for this. There are ways to access the menu through your TV's browser, but not so safe. Detailed [here](https://www.reddit.com/r/OLED_Gaming/comments/sbords/how_to_access_lg_service_menu_without_the_service/). 


## Abbreviations for the curious:
* `ABL`: `Auto Brightness Limiter`
* `ABSL`: `Auto Brightness Static Limiter`
* `TPC`: `Temporal Peak Luminance Control` (TPC). In LG TVs, this is another name for `ASBL` [Reference](https://techprofet.com/lg-tv-auto-dimming/)
* `GSR`: `Global Sticky Reduction`. This feature is designed to detect small parts of a static image and dim those areas a bit. It is the technology behind logo protection feature in many LG OLED TVs. [Reference](https://techprofet.com/lg-tv-auto-dimming/)
* `DDC`: `Data Display Channel`is a collection of protocols for digital communication between a computer display and a graphics adapter that enable the display to communicate its supported display modes to the adapter and that enable the computer host to adjust monitor parameters, such as brightness and contrast. [Reference](https://en.wikipedia.org/wiki/Display_Data_Channel)
* `VRR`: `Variable Refresh Rate`. I.E. systems like `nVidia G-Sync` and `AMD FreeSync`
* `HGiG`: HDR Gaming Interest Group. [Reference](https://www.whathifi.com/advice/hgig-explained-what-is-hgig-how-do-you-get-it-and-should-you-use-it)


