# iOS UI Integration Guide

This document describes how the Aegis iOS app UI integrates with the native scanning engine (XCFramework) through a Swift wrapper.

## Architecture Overview

```
┌─────────────────────────────────────────────┐
│         SwiftUI Views (Screens)             │
│  Home, Scan Results, Quarantine, Settings  │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│      ScanEngine (Coordinator/ViewModel)     │
│  - Manages scan state                       │
│  - Handles results transformation           │
│  - Updates UI with scan progress            │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│   Swift Wrapper (XCFramework Interface)     │
│  - C/C++ FFI calls to scanning engine       │
│  - Rule pack management                     │
│  - Threat detection coordination            │
└────────────────────┬────────────────────────┘
                     │
┌────────────────────▼────────────────────────┐
│  Native Engine (XCFramework/Rust)           │
│  - File scanning (malware, trackers)        │
│  - Rule matching                            │
│  - Evidence collection                      │
└─────────────────────────────────────────────┘
```

## Key Components

### 1. ScanEngine (ViewModel/Coordinator)

The `ScanEngine` class acts as a coordinator between UI and the native scanning engine. It manages scan state, progress, and result transformation.

```swift
class ScanEngine: ObservableObject {
    @Published var scanStatus: ScanStatus = .idle
    @Published var currentScan: ScanSession?
    @Published var results: [ScanResult] = []
    @Published var errorMessage: String?
    
    // Initiate a quick scan
    func startQuickScan() {
        // 1. Update UI state
        // 2. Call native scanner
        // 3. Collect results
        // 4. Update UI with results
    }
    
    // Initiate a full device scan
    func startFullScan() { ... }
    
    // Get quarantined items
    func fetchQuarantineItems() -> [QuarantineItem] { ... }
    
    // Restore quarantined file
    func restoreQuarantineItem(_ item: QuarantineItem) -> Bool { ... }
    
    // Delete quarantined file
    func deleteQuarantineItem(_ item: QuarantineItem) -> Bool { ... }
}
```

### 2. Swift Wrapper Interface

The Swift wrapper provides a type-safe interface to the native scanning engine. It handles all C FFI calls and error transformation.

```swift
// Example wrapper interface (would call C functions)
class NativeScannerWrapper {
    // Initialize the scanner with a rulepack
    func initializeScanner(rulepackPath: String) -> Bool
    
    // Scan a single file
    func scanFile(_ filePath: String) -> ScanResultRaw?
    
    // Scan a directory recursively
    func scanDirectory(_ dirPath: String, completion: @escaping ([ScanResultRaw]) -> Void)
    
    // Get engine version
    func getEngineVersion() -> String
    
    // Get current rulepack version
    func getRulepackVersion() -> String
}
```

### 3. Data Model Transformation

The native engine returns raw C structs. The Swift layer transforms these into type-safe Swift models.

```swift
// Raw C result (from native engine)
struct ScanResultRaw {
    let filename: UnsafePointer<CChar>?
    let filepath: UnsafePointer<CChar>?
    let ruleMatched: UnsafePointer<CChar>?
    let severity: CInt  // 0=low, 1=medium, 2=high
    let evidence: UnsafePointer<CChar>?
}

// Extension to transform to Swift model
extension ScanResult {
    init(from raw: ScanResultRaw) {
        let severity = Severity(rawValue: raw.severity) ?? .low
        self.init(
            id: UUID(),
            filename: String(cString: raw.filename ?? "unknown"),
            filepath: String(cString: raw.filepath ?? ""),
            detail: "Matched rule: \(String(cString: raw.ruleMatched ?? ""))",
            severity: severity,
            ruleMatched: String(cString: raw.ruleMatched ?? ""),
            evidence: String(cString: raw.evidence ?? ""),
            recommendation: severity.recommendation,
            timestamp: Date()
        )
    }
}
```

## Implementation Flow

### Quick Scan Flow

```
1. User taps "Quick Scan" button
   ├─> HomeView calls scanEngine.startQuickScan()
   │
2. ScanEngine updates UI state
   ├─> @Published scanStatus = .scanning
   ├─> HomeView shows loading indicator
   │
3. ScanEngine calls native wrapper
   ├─> NativeScannerWrapper.scanDirectory("/Documents")
   ├─> Native engine scans files in parallel
   │
4. Results collected and transformed
   ├─> ScanResultRaw → ScanResult (Swift models)
   ├─> @Published results updated
   ├─> HomeView displays results
   │
5. Scan completes
   ├─> @Published scanStatus = .completed
   ├─> Last scan date updated
   ├─> UI shows summary
```

### Quarantine Flow

```
1. User selects "Quarantine" for a result
   ├─> ScanResultDetailView calls scanEngine.quarantineItem(result)
   │
2. ScanEngine interacts with file system
   ├─> Move file to quarantine directory
   ├─> Record metadata (original path, rule, scan date)
   ├─> Update persistent storage
   │
3. Quarantine list updated
   ├─> @Published quarantineItems updated
   ├─> QuarantineView refreshes
   │
4. User can restore/delete from quarantine
   ├─> scanEngine.restoreItem(item)
   ├─> scanEngine.deleteItem(item)
   ├─> File system updated
   ├─> UI refreshed
```

## Expected Inputs

### startQuickScan()

**No parameters** - uses default scan paths (Documents, Downloads, temp dirs)

**Expected native behavior**:
- Scan standard locations
- Return within 5-30 seconds (depending on storage size)
- Handle user cancellation gracefully

### startFullScan()

**No parameters** - scans entire device

**Expected native behavior**:
- Scan entire filesystem (with permission)
- May take 1-5 minutes
- Provide progress callbacks every N files
- Handle background app suspension

### scanFile(filePath: String)

**Input**: Absolute file path

**Returns**: ScanResult or nil if no threat

**Expected behavior**:
- Quick scan (< 1 second per file)
- Thread-safe
- No side effects (read-only)

## Expected Outputs

### ScanResult

```swift
struct ScanResult {
    let id: UUID                  // Unique identifier for this result
    let filename: String          // Just the filename
    let filepath: String          // Full path to file
    let detail: String            // Human-readable detail
    let severity: Severity        // High/Medium/Low
    let ruleMatched: String       // Which rule was triggered
    let evidence: String          // Why it matched (technical detail)
    let recommendation: String    // What to do about it
    let timestamp: Date           // When scan occurred
}
```

### ScanSession

```swift
struct ScanSession {
    let id: UUID
    let startTime: Date
    let endTime: Date?
    let status: ScanStatus        // Idle, Scanning, Completed, Failed
    let totalItemsScanned: Int    // Total files examined
    let results: [ScanResult]     // Threats found
    let scanType: ScanType        // Quick, Full, Scheduled, Custom
}
```

## Error Handling

### Native Scanner Errors

```swift
enum ScanError: LocalizedError {
    case initializationFailed
    case rulepackNotFound
    case permissionDenied
    case scanInterrupted
    case invalidPath
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .initializationFailed:
            return "Failed to initialize scanner"
        case .rulepackNotFound:
            return "Rulepack not found. Update in Settings > Rulepacks"
        case .permissionDenied:
            return "Permission denied. Check Privacy settings"
        case .scanInterrupted:
            return "Scan was interrupted"
        case .invalidPath:
            return "Invalid file path"
        case .unknownError(let msg):
            return "Error: \(msg)"
        }
    }
}
```

### UI Error Handling

```swift
func handleScanError(_ error: ScanError) {
    DispatchQueue.main.async {
        self.errorMessage = error.localizedDescription
        self.scanStatus = .failed
        
        // Show alert to user
        // Optionally retry or provide recovery path
    }
}
```

## Threading & Performance

### Background Scanning

```swift
// Scan happens on a background queue
DispatchQueue.global(qos: .userInitiated).async {
    let results = nativeScanner.scanDirectory("/path")
    
    // Update UI on main thread
    DispatchQueue.main.async {
        self.results = results
        self.scanStatus = .completed
    }
}
```

### Cancellation

```swift
var isCancelled = false

func cancelScan() {
    isCancelled = true
    nativeScanner.cancel()  // Signal native code to stop
}

// Native code checks isCancelled periodically
// and returns early if true
```

## Testing Checklist

### Unit Tests

- [ ] ScanResult model creation from raw C struct
- [ ] Severity categorization logic
- [ ] Result filtering (by severity, date)
- [ ] Error enum localization
- [ ] Model encoding/decoding for persistence

### Integration Tests

- [ ] ScanEngine state management
- [ ] Native wrapper FFI calls
- [ ] Concurrent scan operations
- [ ] Scan cancellation
- [ ] Memory cleanup after scan

### UI Tests

- [ ] Quick Scan button flow
- [ ] Results display
- [ ] Quarantine operations
- [ ] Error message display
- [ ] Navigation between screens
- [ ] Dark mode rendering
- [ ] Accessibility (VoiceOver, Dynamic Type)

## Performance Targets

| Operation | Target | Notes |
|-----------|--------|-------|
| Quick Scan | < 30s | Standard device |
| Full Scan | < 5min | 256GB device |
| Single file scan | < 1s | Average file |
| Rule load | < 2s | At app launch |
| Quarantine restore | < 1s | File move |
| UI responsiveness | 60 FPS | Smooth scrolling |

## Security Considerations

1. **File Access**: Only access files with explicit user permission
2. **Data Isolation**: Quarantine data encrypted at rest
3. **Rule Validation**: Cryptographically sign all rulepacks
4. **Memory Safety**: Use Swift's memory safety guarantees
5. **Secure Enclave**: Store encryption keys in Keychain/Secure Enclave

## Next Steps

1. **Implement ScanEngine**: Create the actual coordinator class
2. **Wire Swift Wrapper**: Connect to native scanning engine FFI
3. **Add Persistence**: Save scan history and quarantine items
4. **Implement Scheduling**: Background task for scheduled scans
5. **Add Notifications**: Notify user of threats/completion
6. **Performance Tuning**: Optimize for battery and thermal efficiency

## References

- [XCFramework Documentation](https://developer.apple.com/documentation/xcode/creating_and_using_xcframeworks)
- [SwiftUI State Management](https://developer.apple.com/tutorials/swiftui/state-and-data-flow)
- [Combining Frameworks](https://developer.apple.com/documentation/combine)
- [Performance Best Practices](https://developer.apple.com/videos/play/wwdc2020/10001/)
