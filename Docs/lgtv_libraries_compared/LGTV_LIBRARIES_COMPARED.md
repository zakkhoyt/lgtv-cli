# LG WebOS TV Control Libraries: Comprehensive Comparison

This document compares three prominent Python-based libraries for controlling LG WebOS televisions: LGWebOSRemote, bscpylgtv, and aiopylgtv.

## Quick Reference Table

| Feature | LGWebOSRemote | bscpylgtv | aiopylgtv |
|---------|--------------|-----------|-----------|
| **Language** | Python 3.9+ | Python 3.8+ | Python 3.7+ |
| **Architecture** | Synchronous, WebSocket-based | Async (asyncio), optimized | Async (asyncio) |
| **Last Major Update** | Aug 2025 (community-driven) | Oct 2025 (v0.5.0) | Limited activity 2024-2025 |
| **Active Maintenance** | Community maintained | Actively maintained | Stable maintenance mode |
| **CLI Quality** | Comprehensive, mature | Advanced, script-optimized | Basic utility interface |
| **Calibration Support** | ❌ None | ✅ Professional-grade (optional) | ⚠️ Basic (caution advised) |
| **Best For** | General remote control | Automation & calibration | Home automation integration |
| **License** | MIT | MIT | MIT |

---

## 1. How They Are Built

### LGWebOSRemote (klattimer)
- **Architecture**: Synchronous Python application using WebSocket connections on port 3000
- **Core Technology**: Built on websocket libraries, designed as a command-line first tool
- **Design Philosophy**: Traditional CLI tool with straightforward command execution
- **Communication**: Direct WebSocket protocol implementation for LG's webOS API
- **Platform Support**: Cross-platform (Linux, Windows 10/11, WSL/Ubuntu, macOS)
- **Note**: Depends on third-party websocket libraries that may require updates for Python 3.12+

### bscpylgtv (chros73)
- **Architecture**: Asynchronous Python library using asyncio for non-blocking operations
- **Core Technology**: Fork and complete rewrite of aiopylgtv with performance optimizations
- **Design Philosophy**: Professional-grade tool for both automation and advanced calibration
- **Communication**: Optimized async WebSocket with SQLite for pairing key storage (`.aiopylgtv.sqlite`)
- **Modular Design**: 
  - Base package: TV control only
  - Extended package (`[with_calibration]`): Adds calibration features with numpy dependencies
- **Platform Support**: 
  - Python cross-platform installation via pip
  - Windows portable binaries (no Python required for batch scripting)
- **Drop-in Replacement**: Designed to be compatible with aiopylgtv configurations

### aiopylgtv (bendavid)
- **Architecture**: Asynchronous Python library using asyncio
- **Core Technology**: Modern rewrite of the older pylgtv library
- **Design Philosophy**: Event-driven control for home automation and IoT
- **Communication**: Pure asyncio WebSocket implementation
- **Key Feature**: State update callbacks for real-time monitoring
- **Platform Support**: Python 3.7+ cross-platform

---

## 2. Main Use Cases

### LGWebOSRemote
**Primary Use Case**: Command-line remote control for daily TV operations
- Quick TV control from terminal/scripts
- Network TV discovery and setup
- Media playback control
- Simple automation tasks
- System administrators needing scriptable TV control

### bscpylgtv
**Primary Use Cases**: 
1. **Professional Display Calibration**
   - ISF (Imaging Science Foundation) calibration
   - HDR10 and Dolby Vision tuning
   - 1D/3D LUT (Look-Up Table) management
   - Color gamut adjustments
   - Used by AV professionals and enthusiasts

2. **Advanced Automation**
   - Home theater automation systems
   - Integration with tools like madvr-js-remote and HTWebRemote
   - Batch script operations
   - Rapid command execution scenarios

### aiopylgtv
**Primary Use Cases**: 
- Home automation systems (especially Home Assistant)
- Custom smart home dashboards
- IoT projects requiring non-blocking TV control
- Event-driven applications with state change monitoring
- Running as a service (e.g., on Raspberry Pi)

---

## 3. Unique Capabilities

### LGWebOSRemote - Unique Features
- **Comprehensive CLI Commands**: Most extensive built-in command set
  - `lgtv scan` - Network TV discovery
  - Custom alert creation/management on TV screen
  - Detailed system info queries
  - Foreground app information
- **Wide Model Support**: Extensive list of tested compatible models
- **SSL Support**: Secure connections via `--ssl` flag on most commands
- **Community Documentation**: Years of accumulated community knowledge and troubleshooting

### bscpylgtv - Unique Features
- **Professional Calibration Tools** (unmatched by others):
  - Backup and restore LUTs (1D, 3D color lookup tables)
  - Color matrix manipulation
  - HDR10 and Dolby Vision calibration
  - SDR profiling
  - Integration with professional calibration software (ColourSpace, Calman)
- **Latest TV Support**: Dedicated support for 2024-2025 LG OLED models
- **System Picture Mode Control**: Can set system-wide picture modes (WebOS 2024+)
- **Enhanced Speed**: Optimized for rapid command execution
- **Hidden App Access**: Can list and control hidden system apps
- **Windows Binaries**: No Python installation required for Windows users
- **Comprehensive Settings API**: Direct JSON-based batch operations for complex settings

### aiopylgtv - Unique Features
- **State Update Callbacks**: Real-time notifications of TV state changes
  - Monitor current app changes
  - Track volume changes
  - Detect input switches
- **Pure Async Design**: True non-blocking operations from the ground up
- **Forked from pylgtv**: Inherits stable, well-tested codebase
- **Home Assistant Native**: Designed with Home Assistant integration in mind

---

## 4. Safety Concerns & TV Risk Assessment

### General Safety Considerations
All three libraries interact with LG TVs via official webOS APIs, which are generally safe. However, certain features carry risks.

### LGWebOSRemote - Safety Rating: ✅ SAFE
- **Risk Level**: Low
- **Concerns**: Minimal - only uses standard TV control APIs
- **Potential Issues**: 
  - Rapid command execution might overwhelm older TV models
  - No dangerous low-level access
- **Recommendation**: Safe for all users

### bscpylgtv - Safety Rating: ⚠️ CAUTION (Calibration Features)
- **Risk Level**: Low (basic control), Medium-High (calibration features)
- **Basic Control**: Safe - same API level as other libraries
- **Calibration Features - IMPORTANT WARNINGS**:
  - ⚠️ **LUT uploads can cause TV unresponsiveness** if interrupted or incompatible
  - ⚠️ **Incorrect calibration settings** may require factory reset
  - ⚠️ **Some models lack calibration support** and may behave unexpectedly
  - ⚠️ **Regional variations exist** - some models don't support DDC/LUT features
  - 🔴 **Bricking Risk**: While rare with proper tools, improper calibration CAN make TVs unresponsive
- **Best Practices**:
  - Always backup current settings before calibration
  - Verify your TV model supports calibration features
  - Use tested, documented workflows
  - Never interrupt power/communication during LUT uploads
  - Keep factory reset instructions handy
  - Test on non-critical displays first
- **Recovery**: Most issues resolvable with factory reset; extreme cases may need service mode
- **Recommendation**: 
  - Basic control: Safe for all users
  - Calibration: Advanced users only, with proper research and backups

### aiopylgtv - Safety Rating: ⚠️ CAUTION (Calibration Features)
- **Risk Level**: Low (basic control), High (calibration features)
- **Basic Control**: Safe - standard API usage
- **Calibration Features**:
  - ⚠️ Library includes calibration features but with explicit warnings
  - 🔴 **Can brick your TV if used improperly** (per project documentation)
  - Less documented and tested than bscpylgtv's calibration
- **Recommendation**: 
  - Use basic control features freely
  - **AVOID calibration features unless you're an expert** - use bscpylgtv instead if calibration needed

---

## 5. Setup & First-Time Experience

### LGWebOSRemote
**Ease of Setup**: ⭐⭐⭐⭐ (4/5)

**Installation**:
```bash
pip install lgwebosremote
```

**First Use**:
```bash
# Discover TVs on network
lgtv scan

# Authenticate (requires TV approval)
lgtv --ssl auth <host> <name>

# Start controlling
lgtv audioVolume
```

**Pros**:
- Simple, straightforward workflow
- Built-in network discovery
- Clear authentication process
- Extensive command help

**Cons**:
- May require websocket library updates for Python 3.12+
- SSL flag needed for newer firmwares

### bscpylgtv
**Ease of Setup**: ⭐⭐⭐⭐⭐ (5/5)

**Installation**:
```bash
# Basic control
pip install bscpylgtv

# With calibration features
pip install bscpylgtv[with_calibration]

# Windows: Download portable binary (no Python needed)
```

**First Use**:
```bash
# List all apps
bscpylgtvcommand 192.168.1.18 get_apps_all true

# Change input
bscpylgtvcommand 192.168.1.18 set_input HDMI_2
```

**Pros**:
- Excellent documentation with guides
- Windows binaries lower barrier to entry
- Can use existing aiopylgtv configs
- Comprehensive examples in docs folder
- First-use guide available
- Modular installation (choose basic or full)

**Cons**:
- More complex for calibration setup (by design - requires knowledge)
- Need to know TV's IP address (no built-in discovery shown)

### aiopylgtv
**Ease of Setup**: ⭐⭐⭐ (3/5)

**Installation**:
```bash
pip install aiopylgtv
```

**First Use**:
```python
import asyncio
from aiopylgtv import WebOsClient

async def main():
    client = await WebOsClient.create('192.168.1.53')
    await client.connect()
    apps = await client.get_apps()
    for app in apps:
        print(app)
    await client.disconnect()

asyncio.run(main())
```

**CLI Usage**:
```bash
python -m aiopylgtv.utils 192.168.1.53 set_input HDMI_2
```

**Pros**:
- Simple Python API
- Good for developers

**Cons**:
- Requires Python async knowledge
- CLI is less intuitive (via Python module)
- Minimal documentation for CLI use
- Must write code for most tasks

---

## 6. CLI Interface Comparison

### Winner: LGWebOSRemote 🏆

**LGWebOSRemote** - Score: 10/10
- Dedicated CLI binary (`lgtv`)
- Extensive built-in commands
- Intuitive command naming
- Built-in help system
- Network discovery
- Best for terminal/shell script users
- Example commands:
  ```bash
  lgtv scan
  lgtv audioVolume
  lgtv setPictureMode cinema
  lgtv inputChannelUp
  lgtv listApps
  lgtv createAlert "Hello" "OK"
  ```

**bscpylgtv** - Score: 9/10
- Dedicated CLI binary (`bscpylgtvcommand`)
- Optimized for scripting and automation
- JSON-based batch operations
- Advanced settings control
- Best for batch scripts and automation
- Example commands:
  ```bash
  bscpylgtvcommand 192.168.1.18 get_apps_all true
  bscpylgtvcommand 192.168.1.18 button INFO
  bscpylgtvcommand 192.168.1.18 set_settings picture '{"backlight": 40}'
  ```
- Slightly less intuitive than LGWebOSRemote but more powerful

**aiopylgtv** - Score: 5/10
- No dedicated CLI binary
- Must use Python module invocation
- Minimal CLI documentation
- Best for programmatic use, not CLI
- Example commands:
  ```bash
  python -m aiopylgtv.utils 192.168.1.53 set_input HDMI_2
  ```

### CLI Feature Matrix

| Feature | LGWebOSRemote | bscpylgtv | aiopylgtv |
|---------|--------------|-----------|-----------|
| Dedicated CLI binary | ✅ Yes | ✅ Yes | ❌ No (module) |
| Network discovery | ✅ Yes | ❌ No | ❌ No |
| Help system | ✅ Excellent | ✅ Good | ⚠️ Minimal |
| Command naming | ✅ Intuitive | ✅ Clear | ⚠️ Technical |
| Batch operations | ⚠️ Limited | ✅ Excellent | ❌ Poor |
| Script integration | ✅ Easy | ✅ Excellent | ⚠️ Moderate |
| Windows support | ✅ Yes | ✅ Yes + binaries | ✅ Yes |

---

## 7. Active Maintenance Status

### bscpylgtv - 🟢 ACTIVELY MAINTAINED (Best)
- **Status**: Fully active with frequent updates
- **Latest Release**: v0.5.0 (October 2025)
- **2024-2025 Activity**:
  - v0.4.6 (January 2024): 2020+ model support
  - v0.4.7 (May 2024): 2024/2025 OLED calibration
  - v0.4.8 (May 2024): Calibration enhancements
  - v0.5.0 (October 2025): New APIs, screenshot handling, 2025 TV support
- **Development**: Regular feature additions and bug fixes
- **Community**: Active in AV calibration forums (AVS Forum, AVForums)
- **Documentation**: Continuously updated with new TV models and features
- **Recommendation**: **BEST CHOICE** for long-term use and latest TV support

### LGWebOSRemote - 🟡 COMMUNITY MAINTAINED
- **Status**: Active but community-driven
- **Last Commit**: ~August 2025
- **Maintenance**: Original developer's TV is outdated; community provides updates
- **Activity**: Updates as needed, primarily bug fixes
- **2024-2025 Activity**: 
  - Discussions about webOS 23 compatibility
  - Community testing new models
  - Updated device compatibility list
- **Community**: Active GitHub Discussions
- **Recommendation**: Stable and usable, but slower feature development

### aiopylgtv - 🟠 STABLE MAINTENANCE MODE
- **Status**: Stable but limited new development
- **Activity**: Low visible commit activity in 2024-2025
- **Total History**: 160+ commits (mature codebase)
- **Community Use**: Still used in Home Assistant integrations and AV forums
- **Works With**: Confirmed working with 2024 LG TV models
- **Fork Status**: bscpylgtv is the actively maintained fork
- **Recommendation**: Stable for current use, but consider bscpylgtv for new projects

---

## 8. Links to Other Controllers & Related Projects

### Python-Based Controllers

1. **PyWebOSTV** - https://github.com/supersaiyanmode/PyWebOSTV
   - Synchronous library, actively developed
   - Simpler than aiopylgtv, good for basic scripts
   - Wide adoption in community

2. **AsyncWebOSTV** - https://pypi.org/project/asyncwebostv/
   - Async alternative inspired by PyWebOSTV
   - Modern asyncio implementation
   - Zeroconf discovery support

3. **aiowebostv** - https://github.com/home-assistant-libs/aiowebostv
   - Official Home Assistant library
   - Event-driven design
   - Maintained by Home Assistant team

4. **Alga** - https://github.com/Tenzer/alga
   - Modern CLI utility (Python)
   - Created as improved alternative to LGWebOSRemote
   - Clean interface, actively maintained
   - Community preference for modern Python versions

5. **pylgtv** - https://github.com/TheRealLink/pylgtv (archived)
   - Original library (no longer maintained)
   - Replaced by aiopylgtv

### Professional Calibration Tools

1. **ColourSpace** - https://lightillusion.com/lg_manual.html
   - Commercial calibration software
   - LUT upload support
   - Professional-grade

2. **Portrait Displays Calman** - https://www.portrait.com/
   - Industry-standard calibration
   - LG TV integration
   - Used by professionals

3. **LG White Balance GUI** - Community tool built on bscpylgtv
   - Manual calibration interface
   - Discussed on AVS Forum

### Home Automation Integrations

1. **Home Assistant LG WebOS Integration**
   - Uses aiowebostv library
   - Built-in to Home Assistant
   - Active community support

2. **madvr-js-remote** - Mentioned in bscpylgtv docs
   - Integration with madVR
   - Home theater automation

3. **HTWebRemote** - Mentioned in bscpylgtv docs
   - Home theater remote control

### Alternative/Related Projects

1. **LG WebOS Remote Control** - https://github.com/madmicio/LG-WebOS-Remote-Control
   - JavaScript/Node.js based

2. **RESTRemote** - REST API based control

3. **Magic4pc** - Desktop application

### Official LG Resources

1. **LG webOS TV Developer** - https://webostv.developer.lge.com/
   - Official API documentation
   - Developer tools and CLI
   - SDK downloads

---

## 9. Summary & Recommendations

### Choose **LGWebOSRemote** if:
- ✅ You want a simple, ready-to-use CLI tool
- ✅ You need network TV discovery
- ✅ You're doing basic TV control and automation
- ✅ You prefer mature, community-tested software
- ✅ You want the most intuitive command-line interface
- ❌ You don't need calibration features
- ❌ You don't need the absolute latest TV model support

### Choose **bscpylgtv** if:
- ✅ You need professional display calibration
- ✅ You're working with 2024-2025 LG TV models
- ✅ You want the fastest, most optimized library
- ✅ You need advanced automation with batch scripts
- ✅ You want actively maintained software
- ✅ You need access to hidden TV features
- ✅ You're an AV enthusiast or professional
- ⚠️ You're comfortable with advanced TV settings

### Choose **aiopylgtv** if:
- ✅ You're building a custom Python async application
- ✅ You need state change callbacks
- ✅ You're integrating with Home Assistant
- ✅ You want a proven, stable library
- ❌ You don't need cutting-edge features
- ❌ You're okay with limited CLI interface

### Overall Best Choice

**For Most Users**: **LGWebOSRemote**
- Best CLI experience
- Easiest to learn
- Safe for all users

**For Advanced Users/Latest Support**: **bscpylgtv**
- Most actively maintained
- Best for 2024-2025 TVs
- Professional features
- Best for automation

**For Developers**: **aiopylgtv** or **bscpylgtv**
- Async Python API
- Good for custom applications
- bscpylgtv preferred for active development

---

## 10. Conclusion

All three libraries serve the LG webOS TV control ecosystem well, each with distinct strengths:

- **LGWebOSRemote** excels as a user-friendly, mature CLI tool
- **bscpylgtv** leads in active development, calibration, and latest TV support
- **aiopylgtv** provides a stable async foundation for custom applications

The ecosystem also includes excellent alternatives like PyWebOSTV, Alga, and Home Assistant's aiowebostv, ensuring users have multiple quality options.

For this project's Swift-based implementation, studying these libraries reveals important patterns in TV control, authentication flows, and command structures that can inform development decisions.

---

*Document created: December 2025*
*Research based on current GitHub repositories, PyPI packages, and community forums*
