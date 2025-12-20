# LGTV-CLI Recommendations: Applying Lessons from Python Libraries

This document analyzes the current Swift-based `lgtv-cli` implementation and provides recommendations based on insights from mature Python LGTV control libraries (LGWebOSRemote, bscpylgtv, and aiopylgtv).

## Executive Summary

Our Swift implementation is well-architected with modern async/await patterns using NIO and WebSocketKit. By studying successful Python implementations, we can enhance our CLI interface, improve feature coverage, and provide better user experience while maintaining our Swift-native approach.

---

## 1. Current State Analysis

### Strengths of Our Implementation

✅ **Modern Swift Architecture**
- Built with Swift 5.9+ and async/await
- Uses battle-tested networking (swift-nio, swift-nio-ssl, websocket-kit)
- Clean separation: Library (`LGTVWebOSController`) + CLI (`LGTVControllerCLI`)
- Type-safe with Swift's strong typing
- Native macOS .v14 support

✅ **Professional Structure**
- Package-based architecture
- Separate targets for library and CLI
- Test infrastructure in place
- Uses Swift Argument Parser for CLI

✅ **Core Functionality Present**
- WebSocket-based TV communication
- Configuration storage (`ConfigStore.swift`)
- TV configuration management (`LGTVConfig.swift`)
- Client implementation (`LGTVWebOSClient.swift`)

### Areas for Enhancement

Based on Python library analysis, we can improve:

1. **CLI Feature Completeness** - Expand command coverage
2. **User Experience** - Better discovery and setup flow
3. **Documentation** - More comprehensive guides
4. **Command Organization** - Structured command groups
5. **Safety Features** - Warnings for advanced operations
6. **Calibration Considerations** - Decide if/how to support

---

## 2. CLI Interface Recommendations

### 2.1 Learn from LGWebOSRemote's CLI Excellence

**What Makes LGWebOSRemote's CLI Great:**
- Dedicated binary name: `lgtv` (simple, memorable)
- Intuitive command names: `audioVolume`, `setPictureMode`, `listApps`
- Built-in discovery: `lgtv scan`
- Clear authentication flow: `lgtv --ssl auth <host> <name>`
- Consistent command patterns

**Recommendations for lgtv-cli:**

```swift
// Group commands logically using Swift Argument Parser's command structure

// Current (assumed): lgtv [options] command
// Recommended: Grouped commands

lgtv discover              // Find TVs on network
lgtv connect <ip> [name]   // First-time setup with pairing

// Power & Basic Control
lgtv power on <tv-name>
lgtv power off <tv-name>
lgtv power status <tv-name>

// Volume Control
lgtv volume get <tv-name>
lgtv volume set <tv-name> <level>
lgtv volume up <tv-name>
lgtv volume down <tv-name>
lgtv volume mute <tv-name>
lgtv volume unmute <tv-name>

// Input Control
lgtv input list <tv-name>
lgtv input set <tv-name> <input-id>
lgtv input current <tv-name>

// App Control
lgtv app list <tv-name>
lgtv app launch <tv-name> <app-id>
lgtv app current <tv-name>
lgtv app close <tv-name> <app-id>

// Channel Control (if supported)
lgtv channel up <tv-name>
lgtv channel down <tv-name>
lgtv channel set <tv-name> <channel>

// Media Control
lgtv media play <tv-name>
lgtv media pause <tv-name>
lgtv media stop <tv-name>
lgtv media rewind <tv-name>
lgtv media forward <tv-name>

// Picture Settings
lgtv picture mode <tv-name> <mode>
lgtv picture settings <tv-name>

// System Info
lgtv info system <tv-name>
lgtv info software <tv-name>
lgtv info current-app <tv-name>

// Configuration
lgtv config list              // List configured TVs
lgtv config add <name> <ip>   // Add TV config
lgtv config remove <name>     // Remove TV config
lgtv config show <name>       // Show TV details
```

**Implementation Pattern:**
```swift
// Use Swift Argument Parser's @main and subcommands
@main
struct LGTVCommand: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "lgtv",
        abstract: "Control LG WebOS TVs from the command line",
        subcommands: [
            DiscoverCommand.self,
            ConnectCommand.self,
            PowerCommands.self,
            VolumeCommands.self,
            InputCommands.self,
            AppCommands.self,
            // ... more command groups
        ]
    )
}

// Example subcommand group
struct PowerCommands: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "power",
        abstract: "Power control commands",
        subcommands: [On.self, Off.self, Status.self]
    )
    
    struct On: AsyncParsableCommand {
        @Argument(help: "TV name or IP address")
        var tv: String
        
        func run() async throws {
            // Implementation
        }
    }
}
```

### 2.2 Add Network Discovery (Like LGWebOSRemote)

**Missing Feature:** Network TV discovery

**Recommendation:** Implement SSDP (Simple Service Discovery Protocol) discovery

```swift
// New file: Sources/LGTVWebOSController/Discovery.swift

import Foundation
import Network

/// Discovers LG WebOS TVs on the local network using SSDP
public actor LGTVDiscovery {
    public struct DiscoveredTV {
        public let name: String
        public let ip: String
        public let mac: String?
        public let modelName: String?
        public let serialNumber: String?
    }
    
    /// Scan the network for LG WebOS TVs
    /// - Parameter timeout: How long to scan (default: 5 seconds)
    /// - Returns: Array of discovered TVs
    public func scan(timeout: TimeInterval = 5.0) async throws -> [DiscoveredTV] {
        // Implementation using NIO multicast or Network framework
        // Send SSDP M-SEARCH requests
        // Parse responses
    }
}
```

**CLI Command:**
```bash
lgtv discover
# Output:
# Discovering LG TVs on network...
# Found 2 TVs:
# 1. LG OLED (192.168.1.100) - Model: OLED65C3PSA
# 2. LG Living Room (192.168.1.101) - Model: 55UP8000PUA
```

### 2.3 Improve First-Time Setup (Like bscpylgtv)

**Learn from bscpylgtv:** Clear documentation, guided setup

**Recommendation:** Interactive setup wizard

```swift
// lgtv setup (interactive mode)
Welcome to LGTV CLI Setup!

Step 1: Discovering TVs...
Found 2 TVs on your network:
  1. LG OLED (192.168.1.100)
  2. LG Living Room (192.168.1.101)

Which TV do you want to configure? [1-2]: 1

Step 2: Pairing with TV...
A pairing request has been sent to your TV.
Please check your TV screen and accept the pairing request.

Waiting for approval... [Press Ctrl+C to cancel]

✓ Successfully paired with LG OLED!
✓ Configuration saved.

You can now control your TV with:
  lgtv power on "LG OLED"
  lgtv volume up "LG OLED"

Run 'lgtv --help' for all available commands.
```

---

## 3. Feature Coverage Recommendations

### 3.1 Priority 1: Essential Commands (Implement First)

Based on all three libraries, these are must-have:

**Power Management:**
- ✅ Power on (if supported via Wake-on-LAN with MAC address)
- ✅ Power off
- ✅ Power status

**Volume Control:**
- ✅ Get volume
- ✅ Set volume
- ✅ Volume up/down
- ✅ Mute/unmute

**Input Management:**
- ✅ List inputs
- ✅ Switch input
- ✅ Get current input

**App Management:**
- ✅ List apps
- ✅ Launch app
- ✅ Get foreground app
- ✅ Close app

**Basic Info:**
- ✅ Get system info
- ✅ Get TV status

### 3.2 Priority 2: Enhanced Features

**Media Control:**
```swift
public enum MediaCommand: String {
    case play
    case pause
    case stop
    case rewind
    case fastForward
    case skipForward
    case skipBackward
}
```

**Picture Modes:**
```swift
public enum PictureMode: String {
    case cinema
    case eco
    case expert1
    case expert2
    case game
    case normal
    case photo
    case sports
    case vivid
    // Note: Available modes vary by model
}
```

**Sound Output Control:**
```swift
public enum SoundOutput: String {
    case tvSpeaker = "tv_speaker"
    case external = "external_speaker"
    case externalArc = "external_arc"
    case externalOptical = "external_optical"
    case lineout = "lineout"
    case headphone
    case tvExternalSpeaker = "tv_external_speaker"
    case tvSpeakerHeadphone = "tv_speaker_headphone"
}
```

### 3.3 Priority 3: Advanced Features (Consider Carefully)

**Button Emulation:**
```swift
// Remote control button simulation
public enum RemoteButton: String {
    case home = "HOME"
    case back = "BACK"
    case up = "UP"
    case down = "DOWN"
    case left = "LEFT"
    case right = "RIGHT"
    case enter = "ENTER"
    case info = "INFO"
    case menu = "MENU"
    case channelUp = "CHANNELUP"
    case channelDown = "CHANNELDOWN"
    // ... more buttons
}
```

**Picture Settings (Read Only - SAFE):**
```swift
// Getting picture settings is safe
public struct PictureSettings {
    public let backlight: Int
    public let contrast: Int
    public let brightness: Int
    public let color: Int
    public let sharpness: Int
    // ... more settings
}
```

### 3.4 Priority 4: Calibration Features (⚠️ PROCEED WITH EXTREME CAUTION)

**Recommendation: DO NOT IMPLEMENT Initially**

**Reasoning:**
- **High Risk:** Can make TVs unresponsive or require factory reset
- **Complex:** Requires extensive testing per TV model/year
- **Niche Use Case:** Benefits tiny fraction of users
- **Support Burden:** You'll need to support users who brick TVs
- **Liability:** Even with warnings, users will misuse

**If You Must Implement Later:**

1. **Separate Package/Target:**
   ```swift
   // Package.swift
   .library(
       name: "LGTVWebOSControllerCalibration",
       targets: ["LGTVWebOSControllerCalibration"]
   )
   ```

2. **Explicit Opt-In:**
   ```bash
   # Require explicit flag
   lgtv calibration enable --i-understand-the-risks
   ```

3. **Multiple Warnings:**
   ```swift
   WARNING: Calibration features can make your TV unresponsive!
   
   Before proceeding:
   - Backup your current settings
   - Verify your model is supported
   - Have factory reset instructions ready
   - Never interrupt the calibration process
   
   Type 'I ACCEPT THE RISK' to continue: _
   ```

4. **Model Whitelist:**
   ```swift
   // Only allow tested models
   let supportedCalibrationModels = [
       "OLED65C3PSA",
       "OLED55G3PSA",
       // Only add after extensive testing
   ]
   ```

5. **Backup Requirement:**
   ```swift
   // Force backup before any calibration
   func performCalibration() async throws {
       guard hasBackup else {
           throw CalibrationError.backupRequired
       }
       // ... proceed
   }
   ```

**Alternative:** Document integration with professional tools like Calman or ColourSpace instead of implementing yourself.

---

## 4. Architecture Recommendations

### 4.1 Keep What's Working

✅ **Maintain Current Strengths:**
- Swift's async/await (equivalent to Python's asyncio benefits)
- NIO/WebSocketKit (proven, reliable)
- Separate library and CLI targets
- Swift Argument Parser for CLI

### 4.2 Configuration Management (Learn from bscpylgtv)

**Current:** `ConfigStore.swift` and `LGTVConfig.swift`

**Recommendations:**

```swift
// Enhance LGTVConfig to include more metadata
public struct LGTVConfig: Codable {
    public let name: String              // User-friendly name
    public let ip: String                // IP address
    public let mac: String?              // MAC for Wake-on-LAN
    public let hostname: String?         // Optional hostname
    public let clientKey: String?        // Pairing key
    public let modelName: String?        // TV model (NEW)
    public let modelYear: Int?           // Model year (NEW)
    public let webOSVersion: String?     // webOS version (NEW)
    public let lastConnected: Date?      // Last successful connection (NEW)
    public let notes: String?            // User notes (NEW)
    
    // Feature support flags (determined during discovery/pairing)
    public var supportsWakeOnLAN: Bool { mac != nil }
    public var supportsSSL: Bool = true  // Assume modern TVs
}

// Store in user-friendly location
// macOS: ~/Library/Application Support/lgtv-cli/config.json
// Linux: ~/.config/lgtv-cli/config.json
```

### 4.3 Error Handling (Learn from All Three)

**Add Specific Error Types:**

```swift
public enum LGTVError: Error, LocalizedError {
    case networkUnreachable(String)
    case authenticationRequired
    case authenticationFailed
    case tvNotFound(String)
    case commandNotSupported(String)
    case connectionTimeout
    case invalidResponse(String)
    case tvPoweredOff
    
    public var errorDescription: String? {
        switch self {
        case .networkUnreachable(let ip):
            return "Cannot reach TV at \(ip). Check network connection."
        case .authenticationRequired:
            return "TV requires pairing. Run: lgtv connect <ip>"
        case .authenticationFailed:
            return "Authentication failed. Try pairing again."
        case .tvNotFound(let name):
            return "TV '\(name)' not found in configuration. Run: lgtv config list"
        case .commandNotSupported(let cmd):
            return "Command '\(cmd)' not supported by this TV model."
        case .connectionTimeout:
            return "Connection timeout. Is the TV powered on?"
        case .invalidResponse(let msg):
            return "Invalid response from TV: \(msg)"
        case .tvPoweredOff:
            return "TV appears to be powered off."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .authenticationRequired:
            return "Run 'lgtv connect <ip>' to pair with the TV."
        case .tvNotFound:
            return "Run 'lgtv discover' to find TVs or 'lgtv config add' to add manually."
        case .connectionTimeout:
            return "Ensure the TV is powered on and connected to the network."
        default:
            return nil
        }
    }
}
```

### 4.4 Logging (For Debugging)

**Add Optional Verbose Logging:**

```swift
// Global flag
lgtv --verbose power on "Living Room"

// Shows:
[DEBUG] Loading configuration from /Users/you/.config/lgtv-cli/config.json
[DEBUG] Found TV: Living Room (192.168.1.100)
[DEBUG] Connecting via WebSocket to wss://192.168.1.100:3001
[DEBUG] Sending command: {"type":"request","id":"1","uri":"ssap://system.launcher/open","payload":{}}
[DEBUG] Received response: {"type":"response","id":"1",...}
[INFO] Successfully sent power on command

// Use swift-log for structured logging
import Logging

let logger = Logger(label: "com.lgtv-cli")
```

---

## 5. Documentation Recommendations

### 5.1 Learn from bscpylgtv's Excellent Docs

**bscpylgtv Has:**
- README with quick start
- Detailed first-use guide
- Command reference
- Settings tables per TV model/year
- Calibration guides (separate docs)
- Changelog
- Example scripts

**Recommendations for lgtv-cli:**

```
Docs/
├── README.md                          # Quick start, installation
├── GETTING_STARTED.md                 # Step-by-step first use
├── COMMAND_REFERENCE.md               # All commands with examples
├── CONFIGURATION.md                   # Config file format, options
├── TROUBLESHOOTING.md                 # Common issues and fixes
├── EXAMPLES/                          # Example scripts
│   ├── morning_routine.sh
│   ├── movie_mode.sh
│   └── automation_examples.md
├── TV_COMPATIBILITY.md                # Tested TV models
├── DEVELOPMENT.md                     # For contributors
└── lgtv_libraries_compared/          # (existing)
    ├── LGTV_LIBRARIES_COMPARED.md
    └── LGTV-CLI_RECOMMENDATIONS.md
```

### 5.2 In-App Help

**Command Help Examples:**

```bash
$ lgtv --help
lgtv - Control LG WebOS TVs from the command line

USAGE: lgtv <subcommand>

SUBCOMMANDS:
  discover           Find LG TVs on your network
  connect            Pair with a TV
  power              Power control commands
  volume             Volume control commands
  input              Input management commands
  app                Application control commands
  info               Get TV information
  config             Manage TV configurations

OPTIONS:
  -v, --verbose      Enable verbose logging
  -h, --help         Show help information
  --version          Show version

$ lgtv power --help
OVERVIEW: Power control commands

USAGE: lgtv power <subcommand>

SUBCOMMANDS:
  on                 Turn TV on (requires Wake-on-LAN support)
  off                Turn TV off
  status             Get power status

$ lgtv power on --help
OVERVIEW: Turn TV on (requires Wake-on-LAN support)

USAGE: lgtv power on <tv>

ARGUMENTS:
  <tv>               TV name or IP address

OPTIONS:
  -h, --help         Show help information

EXAMPLES:
  lgtv power on "Living Room"
  lgtv power on 192.168.1.100

NOTE: Wake-on-LAN requires the TV's MAC address in configuration.
      Add MAC during setup: lgtv connect <ip> --mac <mac-address>
```

---

## 6. Safety & Best Practices

### 6.1 Safe By Default

**Implement Safe Commands Only (Initially):**

✅ **Safe Operations:**
- Getting information (read-only)
- Power control (standard API)
- Volume control (standard API)
- Input switching (standard API)
- App launching (standard API)
- Media control (standard API)

⚠️ **Caution Operations:**
- Picture mode changes (safe, but user might not like result)
- Sound output changes (safe, but confusing if user doesn't understand)

❌ **Dangerous Operations (Avoid):**
- Picture setting modifications (contrast, backlight values)
- Any calibration features
- LUT uploads
- Low-level TV configurations

### 6.2 Rate Limiting

**Learn from Issues in Python Libraries:**

```swift
// Prevent overwhelming TV with rapid commands
actor CommandThrottler {
    private var lastCommandTime: ContinuousClock.Instant?
    private let minimumInterval: Duration = .milliseconds(100)
    
    func throttle() async {
        if let last = lastCommandTime {
            let elapsed = ContinuousClock.now - last
            if elapsed < minimumInterval {
                try? await Task.sleep(for: minimumInterval - elapsed)
            }
        }
        lastCommandTime = .now
    }
}
```

### 6.3 Timeout Handling

```swift
// All commands should have reasonable timeouts
func executeCommand<T>(_ operation: @escaping () async throws -> T) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }
        
        group.addTask {
            try await Task.sleep(for: .seconds(10))
            throw LGTVError.connectionTimeout
        }
        
        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}
```

---

## 7. Testing Recommendations

### 7.1 Unit Tests

```swift
// Test configuration management
func testConfigStorage() async throws {
    let config = LGTVConfig(
        name: "Test TV",
        ip: "192.168.1.100",
        mac: "AA:BB:CC:DD:EE:FF",
        clientKey: "test-key"
    )
    
    let store = ConfigStore()
    try await store.save(config)
    
    let loaded = try await store.load(name: "Test TV")
    XCTAssertEqual(loaded.ip, config.ip)
}
```

### 7.2 Integration Tests (Optional)

```swift
// Requires actual TV or mock server
func testRealTVConnection() async throws {
    // Skip in CI
    try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)
    
    let client = LGTVWebOSClient(
        name: "Test",
        ip: "192.168.1.100",
        clientKey: testKey
    )
    
    try await client.connect()
    let info = try await client.getSystemInfo()
    XCTAssertNotNil(info)
}
```

### 7.3 Mock WebSocket Server

```swift
// For reliable automated testing
actor MockWebOSServer {
    // Simulates TV responses
    func start() async throws {
        // Implement mock server
    }
}
```

---

## 8. Implementation Roadmap

### Phase 1: Core CLI Enhancement (2-4 weeks)

1. **Week 1: Command Structure**
   - [ ] Implement command groups (power, volume, input, app)
   - [ ] Add comprehensive help text
   - [ ] Update Package.swift if needed
   - [ ] Basic error handling improvements

2. **Week 2: Essential Commands**
   - [ ] Power control commands
   - [ ] Volume control commands
   - [ ] Input management commands
   - [ ] App management commands

3. **Week 3: Configuration & Discovery**
   - [ ] Enhanced configuration management
   - [ ] Configuration CLI commands
   - [ ] Network discovery implementation (SSDP)
   - [ ] Interactive setup wizard

4. **Week 4: Polish & Documentation**
   - [ ] Complete command help text
   - [ ] Write GETTING_STARTED.md
   - [ ] Write COMMAND_REFERENCE.md
   - [ ] Add examples
   - [ ] Testing

### Phase 2: Enhanced Features (2-3 weeks)

1. **Media Control**
   - [ ] Play/pause/stop commands
   - [ ] Forward/rewind commands

2. **Picture & Sound**
   - [ ] Picture mode switching
   - [ ] Sound output control
   - [ ] Get picture settings (read-only)

3. **Advanced Commands**
   - [ ] Button emulation
   - [ ] Alert/notification display
   - [ ] Channel control (if applicable)

4. **Quality of Life**
   - [ ] Verbose logging option
   - [ ] Config file validation
   - [ ] Better error messages

### Phase 3: Community & Ecosystem (Ongoing)

1. **Documentation**
   - [ ] TV compatibility list
   - [ ] Troubleshooting guide
   - [ ] Video tutorials (optional)

2. **Examples & Scripts**
   - [ ] Shell script examples
   - [ ] Home automation integration guides
   - [ ] macOS Shortcuts integration

3. **Community Building**
   - [ ] GitHub Discussions setup
   - [ ] Issue templates
   - [ ] Contributing guidelines

### Phase 4: Advanced Features (Future - If Needed)

1. **Calibration Support (⚠️ CAREFUL)**
   - [ ] Extensive research
   - [ ] Separate package
   - [ ] Multiple safety warnings
   - [ ] Model whitelist
   - [ ] Comprehensive testing

---

## 9. What NOT to Do

### ❌ Don't Blindly Copy Python Libraries

**Why:**
- Swift has different idioms and patterns
- We have better type safety
- async/await in Swift differs from Python asyncio
- macOS users have different expectations

### ❌ Don't Implement Calibration Features Yet

**Why:**
- High risk, low reward
- Requires extensive per-model testing
- Support burden is huge
- Can damage user's expensive TVs

### ❌ Don't Add Dependencies Unnecessarily

**Why:**
- Current dependencies (NIO, WebSocketKit, ArgumentParser) are excellent
- Keep build times fast
- Minimize supply chain attack surface
- Swift ecosystem values minimal dependencies

### ❌ Don't Sacrifice Type Safety

**Why:**
- Python's dynamic typing allows `AnyCodable` patterns
- Swift should use proper types
- Better to have specific types per command/response

```swift
// Instead of generic:
func sendCommand(_ uri: String, payload: [String: Any]) async throws -> [String: Any]

// Use specific types:
func sendPowerCommand(_ command: PowerCommand) async throws -> PowerResponse
func sendVolumeCommand(_ command: VolumeCommand) async throws -> VolumeResponse
```

### ❌ Don't Ignore Platform Differences

**Why:**
- Python scripts run everywhere the same
- Swift CLI is native to each platform
- Take advantage of macOS integrations
- Consider Shortcuts, AppleScript bridges

---

## 10. Unique Opportunities for Swift Implementation

### Advantages Over Python Libraries

**1. Performance**
- Swift is compiled, significantly faster than Python
- Lower latency for command execution
- Better suited for real-time control

**2. Type Safety**
- Catch errors at compile time
- Better IDE support and autocompletion
- Refactoring is safer

**3. Native Integration**
- NSUserDefaults/UserDefaults for config
- Keychain for sensitive data (client keys)
- macOS Shortcuts integration
- AppleScript bridge potential

**4. Distribution**
- Single binary distribution (no Python installation needed)
- Can be in Homebrew
- Native .pkg installer for macOS
- Eventually: Mac App Store (with GUI wrapper)

**5. Memory Safety**
- Swift's memory safety prevents entire classes of bugs
- Actor isolation prevents race conditions
- Structured concurrency is cleaner than asyncio

### Consider Building

**macOS App (Future)**
```
LGTV Controller.app
├── Menu Bar App
│   └── Quick controls in menu bar
├── Shortcuts Extension
│   └── Native Shortcuts actions
└── CLI Tool
    └── Current lgtv-cli
```

**Shortcuts Integration**
```swift
// Enable Shortcuts actions
import AppIntents

struct PowerOnTVIntent: AppIntent {
    static var title: LocalizedStringResource = "Power On TV"
    
    @Parameter(title: "TV Name")
    var tvName: String
    
    func perform() async throws -> some IntentResult {
        // Implementation
        return .result()
    }
}
```

**AppleScript Bridge**
```applescript
-- Enable AppleScript control
tell application "LGTV Controller"
    power on tv "Living Room"
    set volume of tv "Living Room" to 50
end tell
```

---

## 11. Conclusion

### Key Takeaways

1. **CLI Excellence Matters:** LGWebOSRemote proves that great CLI UX drives adoption
2. **Active Maintenance Wins:** bscpylgtv's success shows value of continued development
3. **Safety First:** Calibration features are powerful but dangerous
4. **Documentation is Critical:** Good docs differentiate good from great projects

### Recommended Next Steps

**Immediate (Do Now):**
1. ✅ Review and understand comparison document
2. ✅ Audit current CLI implementation
3. ✅ Plan command structure using Swift Argument Parser subcommands
4. ✅ Implement core command groups (power, volume, input, app)

**Short Term (Next Month):**
1. Add network discovery
2. Improve configuration management
3. Write comprehensive documentation
4. Add examples and scripts

**Medium Term (Next Quarter):**
1. Expand command coverage
2. Build community
3. Collect user feedback
4. Refine based on real-world usage

**Long Term (Future):**
1. Consider GUI wrapper for macOS
2. Evaluate Shortcuts/AppleScript integration
3. If there's demand AND resources: carefully consider calibration
4. Explore tvOS integration possibilities

### Success Metrics

**You'll know you're successful when:**
- ✅ Users prefer your Swift CLI over Python alternatives on macOS
- ✅ Setup process is simpler than competitors
- ✅ Command names are intuitive and discoverable
- ✅ Documentation helps users succeed without support requests
- ✅ Community contributes examples and scripts
- ✅ Zero TV-bricking incidents (by staying away from calibration initially)

---

## 12. Resources & References

### Study These Implementations

1. **LGWebOSRemote CLI Design**
   - https://github.com/klattimer/LGWebOSRemote
   - Focus on: Command naming, help text, user flow

2. **bscpylgtv Documentation**
   - https://github.com/chros73/bscpylgtv
   - Focus on: Docs structure, first-use guides, examples

3. **Swift Argument Parser Examples**
   - https://github.com/apple/swift-argument-parser
   - Focus on: Subcommand patterns, help generation

4. **Similar Swift CLI Tools**
   - https://github.com/mas-cli/mas (Mac App Store CLI)
   - https://github.com/Homebrew/brew (Package manager)
   - Focus on: Professional CLI UX patterns

### WebOS API References

1. **Official LG Developer Site**
   - https://webostv.developer.lge.com/
   - API documentation

2. **Community Documentation**
   - Python library READMEs have reverse-engineered API details
   - Check GitHub Issues for undocumented features

### Swift & macOS

1. **swift-nio Documentation**
   - https://github.com/apple/swift-nio
   - For understanding networking layer

2. **Swift Concurrency**
   - https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html
   - For proper async/await patterns

---

## Appendix: Command Mapping Reference

### Python → Swift Command Mapping

This table maps common commands from Python libraries to recommended Swift CLI commands:

| Python (LGWebOSRemote) | Python (bscpylgtv) | Recommended Swift | Notes |
|----------------------|-------------------|-------------------|-------|
| `lgtv scan` | N/A | `lgtv discover` | Network discovery |
| `lgtv auth <host>` | First connection | `lgtv connect <ip>` | Pairing |
| `lgtv audioVolume` | `get_volume` | `lgtv volume get <tv>` | Get volume |
| N/A | `set_volume <n>` | `lgtv volume set <tv> <n>` | Set volume |
| N/A | `volume_up` | `lgtv volume up <tv>` | Volume up |
| N/A | `volume_down` | `lgtv volume down <tv>` | Volume down |
| `lgtv listApps` | `get_apps_all` | `lgtv app list <tv>` | List apps |
| N/A | `launch_app <id>` | `lgtv app launch <tv> <id>` | Launch app |
| N/A | `close_app <id>` | `lgtv app close <tv> <id>` | Close app |
| N/A | `set_input <input>` | `lgtv input set <tv> <input>` | Change input |
| `lgtv setPictureMode <mode>` | `set_system_picture_mode` | `lgtv picture mode <tv> <mode>` | Picture mode |
| `lgtv getSystemInfo` | `get_system_info` | `lgtv info system <tv>` | System info |

---

*Document created: December 2025*
*Based on analysis of LGWebOSRemote, bscpylgtv, and aiopylgtv Python libraries*
*For the Swift-based lgtv-cli project*
