
# Binaries
We can use the binary from the .app bundle, or install a cli version (which sounds to be simpler)

## cli binary
* `brew install waydabber/betterdisplay/betterdisplaycli`

```sh
# Get brightness
betterdisplaycli get --name="LG TV SSCR2" --brightness
```

## .app binary
Note I had to allow accessibility for this to work from VScode, but it does work. Terminal seems to work without that step.
```sh
# Get brightness
/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay get --name="LG TV SSCR2" --brightness
```


```sh
# Get brightness
betterdisplaycli get --name="LG TV SSCR2" --brightness

# Set brightness (percent or portion both supported)
betterdisplaycli set --name="LG TV SSCR2" --brightness=100%
betterdisplaycli set --name="LG TV SSCR2" --brightness=1.0
```


# References

* [docs](https://github.com/waydabber/BetterDisplay/wiki/Integration-features,-CLI)
