import Foundation
import ArgumentParser
import LGTVWebOSController
import Network

// MARK: - Auth Command

struct Auth: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Pair with a TV and save credentials",
        discussion: """
        Authenticate and pair with an LG webOS TV. This command will:
        1. Connect to the TV at the specified IP address (or your saved personal IP if none is provided)
        2. Prompt you to accept the pairing request on your TV screen
        3. Save the authentication key to ~/.lgtv/lgtv/config/config.json
        
        Example: lgtv auth --ip-address 192.168.1.100 LivingRoomTV --ssl
        Tip: If you've already paired this TV, you can omit --ip-address and the saved personal IP will be used by default.
        """
    )
    
    @Option(name: [.customLong("ip-address"), .short], help: "IP address of the TV (e.g., 192.168.1.100). Omit to reuse your saved personal IP.")
    var ipAddress: String?
    
    @Argument(help: "Friendly name for the TV (e.g., LivingRoomTV, LGC1)")
    var tvName: String
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss) connection")
    var useSSL: Bool = false
    
    func run() async throws {
        let configStore = ConfigStore()
        let existingConfig = configStore.loadConfig(name: tvName)
        let resolvedIPAddress = try resolveIPAddress(existingConfig: existingConfig)
        
        if ipAddress == nil, let savedIP = existingConfig?.ip {
            print("ℹ️ No --ip-address provided. Using saved IP \(savedIP) for \(tvName).")
        }
        
        print("🔗 Connecting to TV at \(resolvedIPAddress)...")
        print("📺 TV Name: \(tvName)")
        print("🔒 SSL: \(useSSL ? "enabled" : "disabled")")
        print()
        
        // Create client without client key for initial pairing
        let client = LGTVWebOSClient(
            name: tvName,
            ip: resolvedIPAddress,
            mac: nil,
            hostname: nil,
            clientKey: nil,
            useSSL: useSSL
        )
        
        do {
            print("⏳ Establishing connection...")
            try await client.connect()
            
            print()
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("📱 PAIRING REQUEST SENT TO YOUR TV")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print()
            print("👉 Please look at your TV screen now!")
            print("   A pairing request dialog should appear.")
            print()
            print("✅ Press 'Allow' or 'OK' on your TV remote to complete pairing.")
            print()
            print("⏱  Waiting for your response (this may take up to 30 seconds)...")
            print()
            
            // Wait for pairing to complete
            // The handshake in the client will handle the registered response
            try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
            
            // Try to get MAC address from ARP
            let macAddress = (try? getMacAddress(for: resolvedIPAddress)) ?? existingConfig?.mac
            
            // Save configuration
            let config = LGTVConfig(
                name: tvName,
                ip: resolvedIPAddress,
                hostname: existingConfig?.hostname,
                mac: macAddress,
                clientKey: client.currentClientKey ?? existingConfig?.clientKey
            )
            
            try configStore.saveConfig(config)
            
            print()
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("✨ PAIRING SUCCESSFUL!")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print()
            print("📁 Configuration saved to: ~/.lgtv/lgtv/config/config.json")
            if let mac = macAddress {
                print("🔧 MAC Address detected: \(mac)")
            }
            if let key = client.currentClientKey {
                print("🔑 Client key saved: \(key)")
            }
            print()
            print("🎉 You can now control your TV with commands like:")
            print("   lgtv sw-info --name \(tvName)\(useSSL ? " --ssl" : "")")
            print("   lgtv volume-up --name \(tvName)\(useSSL ? " --ssl" : "")")
            print("   lgtv off --name \(tvName)\(useSSL ? " --ssl" : "")")
            print()
            
            await client.disconnect()
            
        } catch {
            print()
            print("❌ Pairing failed: \(error)")
            print()
            print("💡 Troubleshooting tips:")
            print("   1. Make sure your TV is powered on")
            print("   2. Verify the IP address is correct")
            print("   3. Ensure your computer and TV are on the same network")
            print("   4. Try with or without the --ssl flag")
            print()
            throw error
        }
    }
    
    private func getMacAddress(for ip: String) throws -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/arp")
        process.arguments = ["-n", ip]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return nil }
        
        // Parse ARP output for MAC address
        // Format: "? (192.168.1.100) at aa:bb:cc:dd:ee:ff on en0 ifscope [ethernet]"
        let lines = output.components(separatedBy: .newlines)
        for line in lines {
            if line.contains(ip) {
                let components = line.components(separatedBy: " ")
                for (index, component) in components.enumerated() {
                    if component == "at", index + 1 < components.count {
                        let mac = components[index + 1]
                        if mac.contains(":") {
                            return mac
                        }
                    }
                }
            }
        }
        
        return nil
    }
}

extension Auth {
    private func resolveIPAddress(existingConfig: LGTVConfig?) throws -> String {
        if let provided = ipAddress, !provided.isEmpty {
            return provided
        }
        if let saved = existingConfig?.ip, !saved.isEmpty {
            return saved
        }
        throw ValidationError("Missing IP address for \(tvName). Provide --ip-address or ensure the config already stores an IP.")
    }
}

// MARK: - Scan Command

struct Scan: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Scan for LG TVs on the local network",
        discussion: """
        Discover LG webOS TVs on your local network. This command will:
        1. Scan common IP ranges for TVs
        2. Attempt to connect to each potential TV
        3. Display discovered TVs with their details
        
        Provide --ip-address/--ip to override network detection. Accepted formats:
        • Single IP (e.g., 192.168.1.50) – scans that /24 subnet
        • CIDR /24 (e.g., 192.168.1.0/24)
        • Range (e.g., 192.168.1.10-40 or 192.168.1.10-192.168.1.80)
        
        Examples:
          lgtv scan --ssl
          lgtv scan --ssl --ip-address 10.0.20.15
                    lgtv scan --ip 10.0.20.0/24
                    lgtv scan --ssl --debug --ip-address 10.0.20.25
        """
    )
    
    @Flag(name: .customLong("ssl"), help: "Use SSL (wss) when testing connections")
    var useSSL: Bool = false
    
    @Flag(name: .customLong("debug"), help: "Print detailed progress and connection errors during scanning")
    var debug: Bool = false
    
    @Option(name: [.customLong("ip-address"), .customLong("ip")], help: "Seed IP, /24 CIDR, or range (e.g., 192.168.1.10-40) to scan")
    var ipSeed: String?
    
    func run() async throws {
        print("🔍 Scanning for LG webOS TVs on local network...")
        print("🔒 SSL: \(useSSL ? "enabled" : "disabled")")
        if debug {
            print("🐛 Debug mode enabled — showing scan planning and per-IP status.")
        }
        print()
        
        let plan = try buildScanPlan()
        plan.descriptionLines.forEach { print($0) }
        if debug {
            debugPrintTargets(plan.targets)
        }
        print()
        
        let targets = plan.targets
        guard !targets.isEmpty else {
            print("❌ No scan targets were generated. Provide a more specific --ip-address value.")
            return
        }
        
        print("⚡️ Fast probing \(targets.count) address(es) (timeout \(Int(fastProbeTimeoutSeconds))s, concurrency \(fastProbeConcurrency))...")
        let fastResponders = await quickProbeTargets(targets, useSSL: useSSL, debug: debug)
        if debug {
            print("🐛 Fast probe responders: \(fastResponders)")
        }
        print()
        
        guard !fastResponders.isEmpty else {
            print("❌ No TVs responded during the fast probe phase.")
            print()
            printScanTroubleshooting()
            return
        }
        
        print("🔁 Confirming \(fastResponders.count) candidate(s) with a full handshake (timeout \(Int(confirmProbeTimeoutSeconds))s each)...")
        print()
        
        var foundTVs: [(ip: String, info: String)] = []
        
        for testIP in fastResponders {
            if debug {
                print("   🔁 Handshake test for \(testIP)...")
            }
            if let info = await testTV(
                ip: testIP,
                useSSL: useSSL,
                debug: debug,
                timeoutSeconds: confirmProbeTimeoutSeconds
            ) {
                foundTVs.append((testIP, info))
                print("   ✅ Found TV at \(testIP)")
            } else if debug {
                print("   ⚪️ Handshake failed or timed out for \(testIP)")
            }
        }
        
        print()
        
        if foundTVs.isEmpty {
            print("❌ No TVs found after confirming the fast probe candidates")
            print()
            printScanTroubleshooting()
        } else {
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("📺 FOUND \(foundTVs.count) TV(S)")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print()
            
            for (ip, info) in foundTVs {
                print("IP Address: \(ip)")
                print("Info: \(info)")
                print()
                print("To pair with this TV:")
                print("  lgtv auth --ip-address \(ip) MyTV\(useSSL ? " --ssl" : "")")
                print()
                print("────────────────────────────────────────────────")
                print()
            }
        }
    }
    
    private func testTV(ip: String, useSSL: Bool, debug: Bool, timeoutSeconds: TimeInterval) async -> String? {
        let client = LGTVWebOSClient(
            name: "scan",
            ip: ip,
            mac: nil,
            hostname: nil,
            clientKey: nil,
            useSSL: useSSL,
            handshakeExpectation: .promptAcknowledged
        )
        do {
            try await withTimeout(seconds: timeoutSeconds) {
                try await client.connect()
            }
            if debug {
                print("     🔐 Connected to \(ip)")
            }
            
            await client.disconnect()
            if debug {
                print("     🔌 Disconnected from \(ip)")
            }
            
            return "LG webOS TV (connection successful)"
        } catch is ScanTimeoutError {
            await client.disconnect()
            if debug {
                print("     ⏱️ Connection to \(ip) timed out after \(timeoutSeconds)s")
            }
            return nil
        } catch {
            await client.disconnect()
            if debug {
                print("     ⚠️ Connection failed for \(ip): \(error)")
            }
            return nil
        }
    }
    
    private func getLocalIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            
            if addrFamily == UInt8(AF_INET) {
                let name = String(cString: interface.ifa_name)
                
                // Check for active network interfaces (not loopback)
                if name == "en0" || name == "en1" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    
                    // Get the sockaddr size based on address family
                    let addrSize: socklen_t
                    if addrFamily == UInt8(AF_INET) {
                        addrSize = socklen_t(MemoryLayout<sockaddr_in>.size)
                    } else if addrFamily == UInt8(AF_INET6) {
                        addrSize = socklen_t(MemoryLayout<sockaddr_in6>.size)
                    } else {
                        continue
                    }
                    
                    if getnameinfo(interface.ifa_addr,
                                 addrSize,
                                 &hostname,
                                 socklen_t(hostname.count),
                                 nil,
                                 socklen_t(0),
                                 NI_NUMERICHOST) == 0 {
                        address = String(cString: hostname)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
}

extension Scan {
    private struct ScanPlan {
        let descriptionLines: [String]
        let targets: [String]
    }
    
    private func debugPrintTargets(_ targets: [String]) {
        guard !targets.isEmpty else {
            print("🐛 No targets generated.")
            return
        }
        let previewCount = min(20, targets.count)
        let previewList = targets.prefix(previewCount).joined(separator: ", ")
        print("🐛 Target preview (\(previewCount)/\(targets.count)): \(previewList)")
        if targets.count > previewCount {
            print("   ... +\(targets.count - previewCount) more")
        }
    }
    
    private var defaultCommonIPs: [Int] { [100, 101, 102, 110, 150, 200, 10, 20, 50] }
    private var maxScanTargets: Int { 512 }
    private var fastProbeTimeoutSeconds: TimeInterval { 1 }
    private var confirmProbeTimeoutSeconds: TimeInterval { 6 }
    private var fastProbeConcurrency: Int { 32 }
    
    private func buildScanPlan() throws -> ScanPlan {
        if let seed = ipSeed?.trimmingCharacters(in: .whitespacesAndNewlines), !seed.isEmpty {
            return try planFromSeed(seed)
        }
        guard let localIP = getLocalIPAddress() else {
            throw ValidationError("Could not determine local IP address. Provide --ip-address <IP/CIDR/RANGE> to specify the network to scan.")
        }
        let octets = try parseIPv4(localIP)
        let prefix = joinPrefix(from: octets)
        let targets = defaultCommonIPs.map { "\(prefix).\($0)" }
        return ScanPlan(
            descriptionLines: [
                "📡 Local IP: \(localIP)",
                "🌐 Scanning network: \(prefix).0/24 (common addresses: \(defaultCommonIPs.map(String.init).joined(separator: ", ")))",
            ],
            targets: targets
        )
    }
    
    private func planFromSeed(_ seed: String) throws -> ScanPlan {
        if seed.contains("/") {
            return try planFromCIDR(seed)
        }
        if seed.contains("-") {
            return try planFromRange(seed)
        }
        return try planFromSingleIP(seed, reason: "IP")
    }
    
    private func planFromCIDR(_ cidr: String) throws -> ScanPlan {
        let parts = cidr.split(separator: "/")
        guard parts.count == 2 else {
            throw ValidationError("Invalid CIDR format: \(cidr)")
        }
        let seedIP = String(parts[0])
        guard let prefixLength = Int(parts[1]) else {
            throw ValidationError("Invalid CIDR prefix: \(cidr)")
        }
        guard prefixLength == 24 else {
            throw ValidationError("Only /24 CIDR ranges are supported right now (got /\(prefixLength)).")
        }
        return try planFromSingleIP(seedIP, reason: "CIDR /24")
    }
    
    private func planFromRange(_ rawRange: String) throws -> ScanPlan {
        let parts = rawRange.split(separator: "-")
        guard parts.count == 2 else {
            throw ValidationError("Invalid range format: \(rawRange). Use start-end (e.g., 192.168.1.10-40).")
        }
        let startString = String(parts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
        let endStringRaw = String(parts[1]).trimmingCharacters(in: .whitespacesAndNewlines)
        let startOctets = try parseIPv4(startString)
        let endOctets: [Int]
        if endStringRaw.contains(".") {
            endOctets = try parseIPv4(endStringRaw)
        } else {
            guard let last = Int(endStringRaw), (0...255).contains(last) else {
                throw ValidationError("Invalid range end: \(endStringRaw)")
            }
            endOctets = [startOctets[0], startOctets[1], startOctets[2], last]
        }
        guard startOctets[0] == endOctets[0], startOctets[1] == endOctets[1], startOctets[2] == endOctets[2] else {
            throw ValidationError("Range must stay within a single /24 subnet.")
        }
        let prefix = joinPrefix(from: startOctets)
        let start = startOctets[3]
        let end = endOctets[3]
        guard start <= end else {
            throw ValidationError("Range start must be less than or equal to range end.")
        }
        let targets = try makeAddresses(prefix: prefix, start: start, end: end)
        return ScanPlan(
            descriptionLines: [
                "📡 Seed range: \(rawRange)",
                "🌐 Scanning \(targets.count) address(es) in \(prefix).\(start)-\(end)",
            ],
            targets: targets
        )
    }
    
    private func planFromSingleIP(_ ip: String, reason: String) throws -> ScanPlan {
        let octets = try parseIPv4(ip)
        let prefix = joinPrefix(from: octets)
        let targets = prioritizeCommonSuffixes(in: try makeAddresses(prefix: prefix, start: 1, end: 254))
        return ScanPlan(
            descriptionLines: [
                "📡 Seed \(reason): \(ip)",
                "🌐 Scanning derived range: \(prefix).0/24 (\(targets.count) addresses)",
            ],
            targets: targets
        )
    }
    
    private func parseIPv4(_ value: String) throws -> [Int] {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: ".")
        guard parts.count == 4 else {
            throw ValidationError("Invalid IPv4 address: \(value)")
        }
        var octets: [Int] = []
        for part in parts {
            guard let octet = Int(part), (0...255).contains(octet) else {
                throw ValidationError("Invalid IPv4 address: \(value)")
            }
            octets.append(octet)
        }
        return octets
    }
    
    private func joinPrefix(from octets: [Int]) -> String {
        "\(octets[0]).\(octets[1]).\(octets[2])"
    }
    
    private func makeAddresses(prefix: String, start: Int, end: Int) throws -> [String] {
        guard start >= 0, end <= 255, start <= end else {
            throw ValidationError("Invalid address range: \(prefix).\(start)-\(end)")
        }
        let count = end - start + 1
        guard count <= maxScanTargets else {
            throw ValidationError("Range contains \(count) addresses which exceeds the limit of \(maxScanTargets). Provide a narrower range.")
        }
        return (start...end).map { "\(prefix).\($0)" }
    }
    
    private func prioritizeCommonSuffixes(in targets: [String]) -> [String] {
        guard !targets.isEmpty else { return [] }
        var suffixMap: [Int: String] = [:]
        for ip in targets {
            if let suffix = lastOctet(of: ip) {
                suffixMap[suffix] = ip
            }
        }
        var prioritized: [String] = []
        for suffix in defaultCommonIPs {
            if let ip = suffixMap[suffix] {
                prioritized.append(ip)
            }
        }
        let prioritizedSet = Set(prioritized)
        let remainder = targets.filter { !prioritizedSet.contains($0) }
        return prioritized + remainder
    }
    
    private func lastOctet(of ip: String) -> Int? {
        guard let lastComponent = ip.split(separator: ".").last else { return nil }
        return Int(lastComponent)
    }
    
    private func quickProbeTargets(_ targets: [String], useSSL: Bool, debug: Bool) async -> [String] {
        guard !targets.isEmpty else { return [] }
        let port: UInt16 = useSSL ? 3001 : 3000
        var iterator = targets.enumerated().makeIterator()
        var responders: [(index: Int, ip: String)] = []
        await withTaskGroup(of: ProbeResult.self) { group in
            let initial = min(fastProbeConcurrency, targets.count)
            for _ in 0..<initial {
                if let (index, ip) = iterator.next() {
                    group.addTask {
                        let responded = await quickProbe(ip: ip, port: port, timeoutSeconds: fastProbeTimeoutSeconds)
                        return ProbeResult(index: index, ip: ip, responded: responded)
                    }
                }
            }
            while let result = await group.next() {
                if debug {
                    let status = result.responded ? "responded" : "no response"
                    print("   ⚡️ Fast probe \(result.ip): \(status)")
                }
                if result.responded {
                    responders.append((result.index, result.ip))
                }
                if let (index, ip) = iterator.next() {
                    group.addTask {
                        let responded = await quickProbe(ip: ip, port: port, timeoutSeconds: fastProbeTimeoutSeconds)
                        return ProbeResult(index: index, ip: ip, responded: responded)
                    }
                }
            }
        }
        return responders
            .sorted(by: { $0.index < $1.index })
            .map { $0.ip }
    }
    
    private func quickProbe(ip: String, port: UInt16, timeoutSeconds: TimeInterval) async -> Bool {
        await withCheckedContinuation { continuation in
            guard let nwPort = NWEndpoint.Port(rawValue: port) else {
                continuation.resume(returning: false)
                return
            }
            let parameters = NWParameters.tcp
            parameters.allowLocalEndpointReuse = true
            let connection = NWConnection(host: NWEndpoint.Host(ip), port: nwPort, using: parameters)
            let gate = ProbeCompletionGate()
            @Sendable func finish(_ success: Bool) {
                Task {
                    guard await gate.tryFinish() else { return }
                    connection.cancel()
                    continuation.resume(returning: success)
                }
            }
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    finish(true)
                case .failed, .cancelled:
                    finish(false)
                default:
                    break
                }
            }
            connection.start(queue: Scan.fastProbeQueue)
            let milliseconds = Int(timeoutSeconds * 1_000)
            Scan.fastProbeQueue.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
                finish(false)
            }
        }
    }
    
    private func printScanTroubleshooting() {
        print("💡 Troubleshooting:")
        print("   1. Make sure your TV is powered on")
        print("   2. Verify your TV is connected to the same network")
        print("   3. Check if your TV's network settings show an IP address")
        print("   4. Try scanning with --ssl or without it")
        print("   5. Provide --ip-address <IP/CIDR/RANGE> to target a specific subnet")
        print()
    }
    
    private func withTimeout<T>(seconds: TimeInterval, operation: @escaping @Sendable () async throws -> T) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            group.addTask {
                let nanoseconds = UInt64(seconds * 1_000_000_000)
                try await Task.sleep(nanoseconds: nanoseconds)
                throw ScanTimeoutError()
            }
            guard let result = try await group.next() else {
                throw ScanTimeoutError()
            }
            group.cancelAll()
            return result
        }
    }
}

extension Scan {
    private struct ProbeResult: Sendable {
        let index: Int
        let ip: String
        let responded: Bool
    }
    
    private struct ScanTimeoutError: Error {}
    
    private static let fastProbeQueue = DispatchQueue(
        label: "lgtv.scan.fast-probe",
        qos: .utility
    )
    
    private actor ProbeCompletionGate {
        private var finished = false
        func tryFinish() -> Bool {
            if finished {
                return false
            }
            finished = true
            return true
        }
    }
}

// MARK: - Setup Guide Command

struct Setup: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Interactive setup guide",
        discussion: "Step-by-step guide to set up and configure your LG TV for control"
    )
    
    func run() throws {
        print()
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📺 LG TV Control - Setup Guide")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()
        
        printStep(1, "Prerequisites", """
        Before you begin, ensure:
        
        ✓ Your LG TV is powered ON
        ✓ Your TV is connected to your network (WiFi or Ethernet)
        ✓ Your Mac is on the SAME network as your TV
        ✓ You have your TV remote handy (for pairing approval)
        """)
        
        printStep(2, "Check TV Network Settings", """
        On your LG TV:
        
        1. Press the Settings button on your remote
        2. Navigate to: Network → Network Status (or WiFi Connection)
        3. Note your TV's IP address (e.g., 192.168.1.100)
        4. Ensure it shows "Connected to Internet"
        
        📝 Write down the IP address - you'll need it for pairing!
        """)
        
        printStep(3, "Network Connection", """
        ┌─────────────────────────────────────────────────┐
        │  Recommended: Ethernet Connection               │
        │  • More reliable for automation                 │
        │  • Static IP can be configured                  │
        │  • No WiFi sleep issues                         │
        └─────────────────────────────────────────────────┘
        
        ┌─────────────────────────────────────────────────┐
        │  WiFi Connection                                │
        │  • Ensure TV doesn't sleep/disconnect           │
        │  • May need to disable "WiFi Power Saving"     │
        │  • IP address might change (use hostname)       │
        └─────────────────────────────────────────────────┘
        """)
        
          printStep(4, "Discover Your TV", """
          Run the scan command to find your TV:
          $ lgtv scan --ssl
          $ lgtv scan --ssl --ip-address 10.0.50.25
          $ lgtv scan --ip-address 10.0.50.10-40
          This will search your local network for LG TVs.
          If found, it will display the IP address.
          💡 `--ip-address` (alias `--ip`) lets you seed a different /24 subnet or limit the scan to a last-octet range (e.g., 192.168.1.50-80).
              Use it when your Mac isn't on the same VLAN as the TV.
          """)
        
        printStep(5, "Pair with Your TV", """
        Use the auth command with your TV's IP:
        
        $ lgtv auth --ip-address <IP_ADDRESS> <TV_NAME> --ssl
        
        Example:
        $ lgtv auth --ip-address 192.168.1.100 LivingRoom --ssl
        
        What happens:
        • A pairing request appears on your TV screen
        • Use your TV remote to select "Allow" or "OK"
        • Authentication key is saved automatically
        
        ⚡ The --ssl flag is recommended for secure communication.
        """)
        
        printStep(6, "Test Your Connection", """
        Try these commands to verify everything works:
        
        # Get TV software info
        $ lgtv sw-info --name LivingRoom --ssl

        # Control volume
        $ lgtv volume-up --name LivingRoom --ssl
        $ lgtv volume-down --name LivingRoom --ssl

        # Power control
        $ lgtv off --name LivingRoom --ssl
        $ lgtv screen-off --name LivingRoom --ssl
        """)
        
        printStep(7, "HDMI-CEC Considerations", """
        For HDMI-connected Macs:
        
        ✓ Enable HDMI-CEC on your TV (Settings → General → HDMI-CEC)
        ✓ This allows TV to detect Mac power state
        ✓ TV can auto-switch inputs when Mac wakes
        
        Note: CEC behavior varies by TV model and settings.
        """)
        
        printStep(8, "macOS Automation (Optional)", """
        You can automate TV control with:
        
        • Hammerspoon: Monitor Mac sleep/wake events
        • Shell scripts: Create custom automation
        • Keyboard shortcuts: Use macOS Shortcuts app
        
        Example shell alias in ~/.zshrc or ~/.bashrc:
        
        alias tv-on='lgtv screen-on --name LivingRoom --ssl'
        alias tv-off='lgtv screen-off --name LivingRoom --ssl'
        """)
        
        print()
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📚 Additional Resources")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()
        print("• List all commands: lgtv --help")
        print("• Command help: lgtv <command> --help")
        print("• Config location: ~/.lgtv/lgtv/config/config.json")
        print()
        print("🎉 Setup complete! Enjoy controlling your LG TV from the command line!")
        print()
    }
    
    private func printStep(_ number: Int, _ title: String, _ content: String) {
        print("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("┃ Step \(number): \(title)")
        print("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print()
        
        let lines = content.components(separatedBy: .newlines)
        for line in lines {
            print(line)
        }
        
        print()
    }
}
