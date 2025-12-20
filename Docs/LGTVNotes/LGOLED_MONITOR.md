Great post! Super helpful to get me on my way. I did encounter a couple of bumps along the way that I was able to work through (detailed below). I also found that there are with some newer/better tools which I will go into. 

# Hardware Set Up

* Computer: `MacBookPro` (M1Max)
* TV: `LG C1` 
* Connection: `HDMI` (not `USB-C`)

Though I haven't tried, this set up should work with any newer `LG OLED` (C2, C3). Possibly CX.

# Software Set Up

Here are the softwares that I used. The first 3 are required. The rest are optional

## [LGWebOSRemote](https://github.com/klattimer/LGWebOSRemote). 
A `Python` package which exposes an API for your computer to communicate with an `LG TV`.
## [lg-tv-control-macos](https://github.com/cmer/lg-tv-control-macos/). 
## [Hammerspoon](https://github.com/cmer/lg-tv-control-macos/). 
A mac (system menu/start up) app and runs `LUA` scripts to do... whatever. We will use it to tie macOS sleep/wake events to `LGWebOSRemote` commands. A script is provided and is very easy to configure. 
## [MonitorControl](https://github.com/MonitorControl/MonitorControl). 
A mac (system menu/start up) app to control a volume/brightness/contrast of an external display using they keyboard keys (and more). I use it to control the brightness of my `LG C1`, and also to control volume with the help of the next software, `proxy-audio-device`. Note: `MonitorControl` can use `DDC`, but can also work without it.
## [proxy-audio-device](https://github.com/briankendall/proxy-audio-device). 
A mac app which creates virtual audio devices and allows mapping to real audio devices (useful for those of us using a physical `HDMI` connection).
## [Display Menu](https://apps.apple.com/us/app/display-menu/id549083868?mt=12). 
A mac (system menu/start up) app for listing and switching between [resolutions and frame rates](https://i.imgur.com/pkeH9X2.png). 

---

[LGWebOSRemote.](#lgwebosremote) and [Hammerspoon.](#hammerspoon) work together to enable the `LG C1` to wake/sleep along side macOS. Also changes to the correct `HDMI` input on wake. If you are a programmer, you may want to tinker with calling the `LGWebOSRemote` APIs.

[MonitorControl.](#monitorcontrol) allows me to control the brightness of my `LG C1`, but the volume control did not work for me. 

If you are using a `USB-C` connection (not `HDMI`), or if your mac has an Intel processor, then you should be able to control the volume of your LG C1 using only [MonitorControl.](#monitorcontrol), and can skip the next paragraph. 

Those of you who are using `HDMI` (not USB-c) AND also have an Apple Silicon Mac (M1, M2, etc...), Controlling the volume of your `HDMI` device does not work. This is a hardware limitation ([read more here](https://github.com/MonitorControl/MonitorControl/discussions/837#discussioncomment-1880153)). The simplest workaround that I found at the time was `proxy-audio-device`. Here are [the MonitorControl settings](https://imgur.com/a/b5qxzME) that I settled on. Notice that opted not to use `DDC`. Though I did get `DDC` to work, I found that I had a smoother experience without it. 


# Disabling `TPC` (auto-dimming)
I did purchase the service remote for this. There are ways to access the menu through your TV's browser, but not so safe. Detailed [here](https://www.reddit.com/r/OLED_Gaming/comments/sbords/how_to_access_lg_service_menu_without_the_service/). 


# Abbreviations:
* `ABL`: `Auto Brightness Limiter`
* `ABSL`: `Auto Brightness Static Limiter`
* `TPC`: `Temporal Peak Luminance Control` (TPC). In LG TVs, this is another name for `ASBL` [Reference](https://techprofet.com/lg-tv-auto-dimming/)
* `GSR`: `Global Sticky Reduction`. This feature is designed to detect small parts of a static image and dim those areas a bit. It is the technology behind logo protection feature in many LG OLED TVs. [Reference](https://techprofet.com/lg-tv-auto-dimming/)
* `DDC`: `Data Display Channel`is a collection of protocols for digital communication between a computer display and a graphics adapter that enable the display to communicate its supported display modes to the adapter and that enable the computer host to adjust monitor parameters, such as brightness and contrast. [Reference](https://en.wikipedia.org/wiki/Display_Data_Channel)


- [Hardware Set Up](#hardware-set-up)
- [Software Set Up](#software-set-up)
  - [LGWebOSRemote.](#lgwebosremote)
  - [lg-tv-control-macos.](#lg-tv-control-macos)
  - [Hammerspoon.](#hammerspoon)
  - [MonitorControl.](#monitorcontrol)
  - [proxy-audio-device.](#proxy-audio-device)
  - [Display Menu.](#display-menu)
- [Disabling `TPC` (auto-dimming)](#disabling-tpc-auto-dimming)
- [Abbreviations:](#abbreviations)
