



# Basic setup from factory reset (LGC1)

## Disable energy saving
Brighter HDR and SDR presets become available once the energy saver is disabled.
- Go to **Settings > Support > OLED Care > Device Self Care > Energy Saving > Energy Saving Step** and set it to **Off**.

## Turn off the status LED
Removes the standby glow under the panel so the room stays fully dark.
- Navigate to **Settings > General > System > Additional Settings > Standby Light** and switch it **Off**.

## Rename the TV
Having a dedicated name (eg. `Office C1`) makes ThinQ, HomeKit, and MonitorControl pairings easier to spot.
- `Settings -> General -> Devices -> TV Management -> TV Information -> Device Name`

## Hide the LG logo on power events
Keeps the boot/shutdown animation from flashing when automations toggle the screen.
- Open the [Mute Button Menu](#mute-button-menu)
- Set `Show LG logo when turning off the TV` to `Off`

## Disable the "No Signal" picture-frame screensaver
Prevents the ambient art frame from appearing when macOS sleeps the HDMI output.
- Open the [Mute Button Menu](#mute-button-menu)
- Set `No Signal Image` to `Off`

# System privacy and device settings

## Advertising ID and limit tracking
- `Settings -> General -> System -> Additional Settings -> Advertising ID`
  - Toggle `Personalized Advertising` to `Off` to opt out of targeted ads.
  - Select `Reset Advertising ID` afterwards so existing data is cleared.

## Computer device settings
- `Settings -> General -> Devices -> HDMI Settings`
  - Set the HDMI port your Mac uses to `PC`. This unlocks PC-specific chroma and Game Optimizer defaults.
- `Settings -> General -> Devices -> TV Management -> TV On With Mobile` -> `On` for reliable wake events via ThinQ/Hammerspoon.

### Audio setup for computer
- `Settings -> Sound -> Sound Mode -> AI Sound Pro` for balanced EQ when using the TV speakers.
- `Settings -> Sound -> Advanced Settings -> Installation Type -> Wall-mounted` even for a stand mount if the panel sits near a wall (reduces bass bloom).
- If routing audio back to a receiver, enable `Settings -> Sound -> Additional Settings -> eARC`.

## Connecting to the LG ThinQ app
1. Install the [LG ThinQ](https://www.lg.com/global/lg-thinq) mobile app.
2. Ensure the TV and phone share the same Wi-Fi. On the TV go to `Settings -> General -> Devices -> TV Management -> TV Information` to confirm network status.
3. In ThinQ, tap `+` -> `Add Device` -> `TV` -> `LG TV`, enter the pairing PIN shown on the TV, and finish the prompts.

## Connecting to HomeKit / AirPlay
1. Press `Home`, open `Home Dashboard`, and choose `AirPlay & HomeKit Settings`.
2. Select `Set Up HomeKit`, then scan the QR code with the iOS Home app.
3. Assign the TV to a room and scenes so Siri automations can target it.

## Input names
- `Settings -> General -> Devices -> HDMI Input Settings -> Edit` lets you rename each HDMI source (eg. `MacBook Pro`).
- Pick the computer icon to keep 4:4:4 chroma and PC picture mode.

## Quick Access shortcuts
1. Tune to the input/app you want to store.
2. Long-press a number key (1-9) on the Magic Remote until the Quick Access dialog appears.
3. Confirm to bind that slot; repeat for other shortcuts. Long-pressing the same number later jumps straight to the saved destination.

# Picture mode tuning
This TV displays different picture modes according to the signal it receives. Feed it HDR from a PS5 or Mac to unlock the HDR-specific options below.

## Game Optimizer baseline
- `Settings -> Picture -> HDR Select Mode -> Game Optimizer`
- Keep `Picture Mode Settings -> Genre` on `Standard` or `FPS` for the lowest latency.
- Inside `Game Optimizer -> Fine Tune Dark Areas`, leave the slider at `0` unless you need to raise shadows.
- `Advanced Settings -> Reduce Input Lag -> Boost` engages the fastest signal path.
- Turn off interpolation: `Advanced Settings -> TruMotion -> Off` (disables OLED Motion Pro).
- Under `Advanced Settings -> Clarity`, leave `Sharpness`, `Super Resolution`, and `Noise Reduction` at neutral defaults so 4:4:4 text stays crisp.

## HGiG (HDR Gaming Interest Group)
`HGiG` only appears when the TV detects an HDR signal ([reference](https://www.reddit.com/r/OLED_Gaming/comments/q5fjox/lg_c1_and_hgig_on_the_series_x/)).
- `Settings -> Picture -> Advanced -> Brightness -> HDR Tone Mapping -> HGiG`





