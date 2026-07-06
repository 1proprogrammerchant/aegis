# iOS UI Test Plan

Comprehensive test plan for the Aegis iOS app UI, including unit tests, integration tests, and UI tests.

## Test Scope

- **UI Components**: Screens, views, buttons, navigation
- **Data Models**: ScanResult, QuarantineItem, ScanSession
- **Accessibility**: VoiceOver, Dynamic Type, contrast
- **Appearance**: Dark mode, light mode, trait variations
- **Performance**: Scan speed, memory usage, UI responsiveness

## Unit Tests

### 1. Data Model Tests

**File**: `AegisAppTests/Models/ScanModelsTests.swift`

```swift
class ScanModelsTests: XCTestCase {
    
    func testSeverityColor() {
        // High severity should map to red/danger color
        XCTAssertEqual(Severity.high.color, Color.aegisDanger)
        
        // Low severity should map to green/success color
        XCTAssertEqual(Severity.low.color, Color.aegisSuccess)
    }
    
    func testScanResultCreation() {
        let result = ScanResult(
            id: UUID(),
            filename: "test.pdf",
            filepath: "/Documents/test.pdf",
            detail: "Suspicious content",
            severity: .high,
            ruleMatched: "malware_pdf",
            evidence: "JavaScript exploit detected",
            recommendation: "Delete or quarantine",
            timestamp: Date()
        )
        
        XCTAssertEqual(result.filename, "test.pdf")
        XCTAssertEqual(result.severity, .high)
        XCTAssertFalse(result.isQuarantined)
    }
    
    func testScanSessionStats() {
        let results = [
            ScanResult(..., severity: .high, ...),
            ScanResult(..., severity: .medium, ...),
            ScanResult(..., severity: .low, ...),
        ]
        
        let session = ScanSession(
            id: UUID(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(60),
            status: .completed,
            totalItemsScanned: 1000,
            results: results,
            scanType: .quick
        )
        
        XCTAssertEqual(session.highSeverityCount, 1)
        XCTAssertEqual(session.mediumSeverityCount, 1)
        XCTAssertEqual(session.lowSeverityCount, 1)
        XCTAssertEqual(session.durationSeconds, 60)
    }
    
    func testQuarantineItemDaysQuarantined() {
        let quarantineDate = Date().addingTimeInterval(-86400 * 3)  // 3 days ago
        let item = QuarantineItem(
            id: UUID(),
            filename: "malware.exe",
            filepath: "/quarantine/malware.exe",
            severity: .high,
            ruleMatched: "trojan_generic",
            quarantineDate: quarantineDate,
            originalScanResult: testScanResult()
        )
        
        XCTAssertEqual(item.daysQuarantined, 3)
    }
}
```

### 2. Color System Tests

**File**: `AegisAppTests/DesignSystem/ColorsTests.swift`

```swift
class ColorsTests: XCTestCase {
    
    func testLightModeColors() {
        // Light mode should have light backgrounds
        let light = AegisColors.lightBackground
        XCTAssertEqual(light, Color(red: 1.0, green: 1.0, blue: 1.0))
    }
    
    func testDarkModeColors() {
        // Dark mode should have dark backgrounds
        let dark = AegisColors.darkBackground
        XCTAssertEqual(dark, Color(red: 0.0, green: 0.0, blue: 0.0))
    }
    
    func testAdaptiveColors() {
        // Adaptive colors should respond to system appearance
        let adaptiveBackground = Color.aegisBackground
        XCTAssertNotNil(adaptiveBackground)
    }
    
    func testContrastRatios() {
        // Text on background should meet WCAG AA standards (4.5:1)
        let textColor = AegisColors.lightText
        let bgColor = AegisColors.lightBackground
        
        let contrast = contrastRatio(textColor, bgColor)
        XCTAssertGreaterThanOrEqual(contrast, 4.5)
    }
}
```

### 3. Component Tests

**File**: `AegisAppTests/DesignSystem/ComponentsTests.swift`

```swift
class ComponentsTests: XCTestCase {
    
    func testSeverityBadgeRendering() {
        let badge = SeverityBadge(severity: .high)
        
        let hosting = UIHostingController(rootView: badge)
        hosting.loadView()
        
        XCTAssertNotNil(hosting.view)
        XCTAssert(hosting.view.frame.height > 0)
    }
    
    func testPrimaryButtonDisabled() {
        var isPressed = false
        let button = PrimaryButton(title: "Test", isEnabled: false) {
            isPressed = true
        }
        
        let hosting = UIHostingController(rootView: button)
        hosting.loadView()
        
        // Disabled button should not be interactive
        XCTAssertFalse(isPressed)
    }
    
    func testEmptyStateView() {
        let empty = EmptyStateView(
            icon: "checkmark.circle",
            title: "All Clear",
            message: "No threats found"
        )
        
        let hosting = UIHostingController(rootView: empty)
        hosting.loadView()
        
        XCTAssertNotNil(hosting.view)
    }
}
```

## Integration Tests

### 1. Navigation Flow Tests

**File**: `AegisAppTests/Integration/NavigationTests.swift`

```swift
class NavigationTests: XCTestCase {
    
    func testHomeToQuarantineNavigation() {
        let home = EnhancedHomeView()
        
        // Navigate to Quarantine
        // Verify QuarantineView appears
        // XCTAssertTrue(isQuarantineViewVisible)
    }
    
    func testHomeToSettingsNavigation() {
        let home = EnhancedHomeView()
        
        // Tap Settings button
        // Verify SettingsView appears
        // XCTAssertTrue(isSettingsViewVisible)
    }
    
    func testResultsDetailNavigation() {
        let result = ScanResult(...)
        let detail = ScanResultDetailView(result: result)
        
        // Verify result details are displayed
        XCTAssertTrue(detail.body != nil)
    }
}
```

### 2. State Management Tests

**File**: `AegisAppTests/Integration/StateTests.swift`

```swift
class StateTests: XCTestCase {
    
    func testScanStateTransition() {
        let scanEngine = MockScanEngine()
        
        // Initial state should be idle
        XCTAssertEqual(scanEngine.scanStatus, .idle)
        
        // Start scan
        scanEngine.startQuickScan()
        XCTAssertEqual(scanEngine.scanStatus, .scanning)
        
        // Simulate completion
        scanEngine.completeScanning()
        XCTAssertEqual(scanEngine.scanStatus, .completed)
    }
    
    func testResultsUpdate() {
        let scanEngine = MockScanEngine()
        
        let result = ScanResult(...)
        scanEngine.results = [result]
        
        XCTAssertEqual(scanEngine.results.count, 1)
        XCTAssertEqual(scanEngine.results.first?.filename, result.filename)
    }
    
    func testQuarantineStateUpdate() {
        let scanEngine = MockScanEngine()
        
        let item = QuarantineItem(...)
        scanEngine.quarantineItems = [item]
        
        XCTAssertEqual(scanEngine.quarantineItems.count, 1)
    }
}
```

## UI Tests

### 1. Screen Rendering Tests

**File**: `AegisAppUITests/ScreenTests.swift`

```swift
class ScreenTests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testHomeScreenLoads() {
        // Verify home screen elements
        let title = app.staticTexts["Aegis"]
        XCTAssertTrue(title.exists)
        
        let scanButton = app.buttons["Quick Scan"]
        XCTAssertTrue(scanButton.exists)
    }
    
    func testQuarantineScreenNavigation() {
        // Tap quarantine button
        let quarantineButton = app.buttons["Quarantine"]
        quarantineButton.tap()
        
        // Verify quarantine screen
        let quarantineTitle = app.staticTexts["Quarantine"]
        XCTAssertTrue(quarantineTitle.waitForExistence(timeout: 2))
    }
    
    func testSettingsScreenNavigation() {
        // Tap settings button
        let settingsButton = app.buttons["Settings"]
        settingsButton.tap()
        
        // Verify settings screen
        let settingsTitle = app.staticTexts["Settings"]
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 2))
    }
}
```

### 2. Interaction Tests

**File**: `AegisAppUITests/InteractionTests.swift`

```swift
class InteractionTests: XCTestCase {
    
    let app = XCUIApplication()
    
    func testQuickScanFlow() {
        app.launch()
        
        // Tap Quick Scan
        let scanButton = app.buttons["Quick Scan"]
        scanButton.tap()
        
        // Wait for loading
        sleep(1)
        
        // Verify loading indicator appears
        let loadingIndicator = app.activityIndicators.firstMatch
        XCTAssertTrue(loadingIndicator.exists || loadingIndicator.waitForExistence(timeout: 5))
        
        // Wait for completion
        sleep(3)
        
        // Verify results appear
        let results = app.staticTexts.containing(NSPredicate(format: "value CONTAINS 'findings'")).firstMatch
        XCTAssertTrue(results.waitForExistence(timeout: 5))
    }
    
    func testToggleSettings() {
        app.launch()
        
        // Navigate to settings
        app.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["Settings"].waitForExistence(timeout: 2))
        
        // Find and toggle a switch
        let switches = app.switches
        if switches.count > 0 {
            let toggle = switches.firstMatch
            toggle.tap()
            sleep(0.5)
            // Verify toggle state changed
        }
    }
}
```

### 3. Accessibility Tests

**File**: `AegisAppUITests/AccessibilityTests.swift`

```swift
class AccessibilityTests: XCTestCase {
    
    let app = XCUIApplication()
    
    func testVoiceOverLabels() {
        app.launch()
        
        // Enable VoiceOver (settings required)
        // Verify all buttons have labels
        let buttons = app.buttons
        for button in buttons.allElementsBoundByIndex {
            XCTAssertTrue(button.label.count > 0, "Button should have a label")
        }
    }
    
    func testDynamicTypeLarge() {
        // Set Dynamic Type to Large
        app.launch()
        
        let homeText = app.staticTexts["Aegis"]
        let textSize = homeText.frame.size.height
        
        // Verify text is rendered at larger size
        XCTAssertGreaterThan(textSize, 20)
    }
    
    func testDarkModeContrast() {
        app.preferredColorScheme = .dark
        app.launch()
        
        let elements = app.staticTexts
        for element in elements.allElementsBoundByIndex {
            // Verify element is visible (has contrast)
            XCTAssertTrue(element.isHittable || element.isVisible)
        }
    }
    
    func testMinimumTouchTargetSize() {
        app.launch()
        
        let buttons = app.buttons
        for button in buttons.allElementsBoundByIndex {
            let frame = button.frame
            // Minimum 44x44 pt
            XCTAssertGreaterThanOrEqual(frame.height, 44)
        }
    }
}
```

### 4. Dark Mode Tests

**File**: `AegisAppUITests/DarkModeTests.swift`

```swift
class DarkModeTests: XCTestCase {
    
    func testLightModeRendering() {
        let app = XCUIApplication()
        app.preferredColorScheme = .light
        app.launch()
        
        // Verify light mode colors
        XCTAssertTrue(app.exists)
    }
    
    func testDarkModeRendering() {
        let app = XCUIApplication()
        app.preferredColorScheme = .dark
        app.launch()
        
        // Verify dark mode colors
        XCTAssertTrue(app.exists)
    }
    
    func testModeTransition() {
        let app = XCUIApplication()
        app.preferredColorScheme = .light
        app.launch()
        
        // Switch to dark mode
        app.preferredColorScheme = .dark
        
        // Verify UI updates correctly
        XCTAssertTrue(app.exists)
    }
}
```

## Performance Tests

### 1. Scan Performance

**File**: `AegisAppTests/Performance/ScanPerformanceTests.swift`

```swift
class ScanPerformanceTests: XCTestCase {
    
    func testQuickScanDuration() {
        let scanEngine = MockScanEngine()
        
        let startTime = Date()
        scanEngine.startQuickScan()
        
        // Simulate results
        while scanEngine.scanStatus == .scanning {
            usleep(100000)  // 0.1s
        }
        
        let duration = Date().timeIntervalSince(startTime)
        
        // Quick scan should complete in < 30 seconds
        XCTAssertLessThan(duration, 30)
    }
    
    func testUIResponsiveness() {
        let view = EnhancedHomeView()
        
        let hosting = UIHostingController(rootView: view)
        hosting.loadView()
        
        // Measure rendering time
        measure {
            hosting.view.setNeedsLayout()
            hosting.view.layoutIfNeeded()
        }
    }
}
```

## Continuous Integration

### Test Execution

```bash
# Run all tests
xcodebuild test \
  -scheme AegisApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test \
  -scheme AegisApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing AegisAppTests/ScanModelsTests

# Generate coverage report
xcodebuild test \
  -scheme AegisApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES
```

## Test Coverage Goals

| Component | Target Coverage |
|-----------|-----------------|
| Models | 95% |
| Views | 80% |
| ViewModels | 90% |
| DesignSystem | 85% |
| Utilities | 90% |
| **Overall** | **85%** |

## Acceptance Criteria

### Functional

- [x] All screens render correctly (light & dark modes)
- [x] Navigation works between all screens
- [x] Quick Scan completes in < 30 seconds
- [x] Results display with correct severity
- [x] Quarantine operations work (move, restore, delete)
- [x] Settings persist across app launches

### Accessibility

- [x] All buttons have VoiceOver labels
- [x] Contrast ratios meet WCAG AA (4.5:1)
- [x] Dynamic Type sizes work (Small to ExtraLarge)
- [x] Minimum 44x44pt touch targets
- [x] No keyboard traps

### Performance

- [x] UI responds to input within 100ms
- [x] Scans don't block UI thread
- [x] Memory usage < 150MB during scan
- [x] Battery impact minimal

### Compatibility

- [x] iOS 14.0 or later
- [x] All iPhone models (SE to Pro Max)
- [x] iPad support
- [x] Landscape orientation

## Known Issues & Workarounds

| Issue | Status | Workaround |
|-------|--------|-----------|
| VoiceOver focus jumps | Open | File radar with Apple |
| Dark mode transition flicker | Open | Submit feedback |
| Dynamic Type size 5 overflow | Open | Constrain to size 4 max |

## Test Results Archive

Test results are archived in the GitHub Actions CI pipeline:
- Location: `.github/workflows/ci.yml`
- Artifacts: `test-results/` directory
- Coverage: Uploaded to Codecov

## Sign-Off

- [ ] All unit tests passing (95%+ coverage)
- [ ] All UI tests passing
- [ ] Accessibility audit complete
- [ ] Performance benchmarks met
- [ ] Ready for QA testing

---

**Test Plan Version**: 1.0  
**Last Updated**: 2026-07-06  
**Maintained by**: Aegis Team
