# Accessibility Guidelines for Aegis iOS App

The Aegis app must be accessible to all users, including those with disabilities. This guide ensures WCAG AA compliance and provides best practices for accessible iOS development.

## WCAG 2.1 AA Compliance

### Perceivable

#### 1.4.3 Contrast (Minimum)

Text and interactive components must have a contrast ratio of at least 4.5:1 (large text: 3:1).

**Checking Contrast**:
- Use Xcode's accessibility inspector
- Use WCAG contrast checker: https://webaim.org/resources/contrastchecker/
- Light theme baseline: `#1C1C1E` text on `#FFFFFF` background = 12.6:1 ✓
- Dark theme baseline: `#FFFFFF` text on `#000000` background = 21:1 ✓

**Severity Colors**:
- High (danger): `#FF3B30` on `#FFFFFF` = 3.5:1 ✗ → Use badge background
- High (danger): `#FF3B30` on `#FFE5E1` = 5.1:1 ✓
- Medium (warning): `#FF9500` on `#FFFFFF` = 5.8:1 ✓
- Low (success): `#34C759` on `#FFFFFF` = 3.8:1 ✗ → Use label not text

**Implementation**:
```swift
// Use semantic colors or check contrast at runtime
if colorScheme == .dark {
    return Color(red: 1.0, green: 0.271, blue: 0.227) // #FF453A
} else {
    return Color(red: 1.0, green: 0.235, blue: 0.188) // #FF3B30
}
```

#### 1.4.5 Images of Text

Avoid embedding text in images. Use SwiftUI Text views instead.

**✗ Avoid**:
```swift
Image("button-text-image") // Text embedded in image
```

**✓ Correct**:
```swift
Button(action: {}) {
    Label("Quick Scan", systemImage: "magnifyingglass")
}
```

### Operable

#### 2.1.1 Keyboard Access

All functionality must be operable via keyboard. VoiceOver on iOS provides keyboard-like navigation.

#### 2.1.2 No Keyboard Trap

Users must not get stuck in elements when using keyboard navigation.

**Implementation**:
- Use standard SwiftUI controls (Button, TextField, etc.)
- Test with Switch Control or external keyboard

#### 2.4.3 Focus Order

VoiceOver focus order should be logical and match visual layout.

**Implementation**:
```swift
VStack {
    TextField("Search", text: $query)
        .accessibilityLabel("Search quarantined items")
    
    Button("Clear") {
        query = ""
    }
    .accessibility(label: Text("Clear search"))
    .accessibility(hint: Text("Removes all text from search field"))
}
```

#### 2.5.1 Pointer Gestures

Provide alternative to complex gestures (pinch, rotate, swipe).

**✗ Avoid**:
```swift
.gesture(
    MagnificationGesture()
        .onChanged { scale in
            // pinch-only zoom
        }
)
```

**✓ Correct**:
```swift
Picker("Zoom Level", selection: $zoom) {
    Text("Small").tag(0.8)
    Text("Medium").tag(1.0)
    Text("Large").tag(1.2)
}
.accessibilityElement(children: .combine)
```

#### 2.5.5 Target Size (Enhanced)

Minimum touch target: 44x44pt (recommended: 48x48pt for security apps)

**Implementation**:
```swift
Button(action: {}) {
    Text("Scan")
}
.frame(minHeight: 44)
.frame(minWidth: 44)
```

### Understandable

#### 3.2.1 On Focus

Focus should not trigger unexpected context changes.

**✗ Avoid**:
```swift
TextField("Email", text: $email)
    .onChange(of: email) { newValue in
        // Unexpected navigation on focus
        navigateTo(nextScreen)
    }
```

#### 3.3.1 Error Identification

Error messages must be clear and actionable.

**✓ Correct**:
```swift
// Clear error message
Text("Scan failed: No rulepack installed. Go to Settings to update.")
    .foregroundColor(.danger)
    .accessibility(label: Text("Error"))
    .accessibility(hint: Text("Scan failed: No rulepack installed"))
```

#### 3.3.4 Error Prevention (Enhanced)

For critical operations (delete, restore), provide confirmation dialogs.

**Implementation**:
```swift
.confirmationDialog("Delete item?", isPresented: $showDelete) {
    Button("Delete Permanently", role: .destructive) {
        deleteItem()
    }
    Button("Cancel", role: .cancel) {}
} message: {
    Text("This action cannot be undone.")
}
```

### Robust

#### 4.1.2 Name, Role, Value

All UI components must have accessible name, role, and value.

**Implementation - Button**:
```swift
Button(action: { startScan() }) {
    Image(systemName: "magnifyingglass")
}
.accessibility(label: Text("Quick Scan"))
.accessibility(hint: Text("Scans your device for threats"))
```

**Implementation - Custom Control**:
```swift
ZStack {
    Rectangle()
        .fill(Color.blue)
    
    Text("Custom Button")
}
.frame(height: 44)
.accessibilityElement()
.accessibility(label: Text("Custom Button"))
.accessibility(role: .button)
.accessibility(addTraits: .isButton)
.onTapGesture {
    action()
}
```

## VoiceOver Best Practices

### 1. Meaningful Labels

Every interactive element must have a clear, concise label:

```swift
// ✗ Poor
Button(action: {}) {
    Image(systemName: "arrow.clockwise")
}

// ✓ Good
Button(action: {}) {
    Image(systemName: "arrow.clockwise")
}
.accessibility(label: Text("Refresh"))
.accessibility(hint: Text("Reloads the scan results"))
```

### 2. Combining Views

Use `accessibilityElement(children:)` to group related views:

```swift
HStack {
    Image(systemName: "exclamationmark.circle")
        .foregroundColor(.red)
    VStack(alignment: .leading) {
        Text("High Severity")
        Text("Malware detected")
    }
}
.accessibilityElement(children: .combine)
.accessibility(label: Text("High Severity Threat"))
```

### 3. Custom Actions

Add custom actions for common operations:

```swift
Button(action: {}) {
    Text("Quarantined File")
}
.accessibility(customActions: [
    AccessibilityCustomAction(name: "Restore", target: self, selector: #selector(restore)),
    AccessibilityCustomAction(name: "Delete", target: self, selector: #selector(delete))
])
```

### 4. Focus Management

Ensure focus moves to newly presented content:

```swift
@State private var showSheet = false

Sheet(isPresented: $showSheet) {
    VStack {
        TextField("Search", text: $query)
            .accessibility(label: Text("Search results"))
            .accessibilityFocused($isFocused)
    }
}
```

## Dynamic Type Support

Aegis must support Dynamic Type sizes from **Small** to **ExtraLarge**.

### Implementation

```swift
VStack(spacing: 12) {
    Text("Scan Results")
        .font(.system(.title2, design: .default))
        .dynamicTypeSize(.small ... .extraLarge)
    
    List(results) { result in
        HStack {
            VStack(alignment: .leading) {
                Text(result.title)
                    .font(.headline)
                Text(result.detail)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            Spacer()
            SeverityBadge(result.severity)
        }
    }
}
```

### Testing Dynamic Type

In Xcode Previews:
```swift
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environment(\.sizeCategory, .small)
                .preferredColorScheme(.light)
            
            HomeView()
                .environment(\.sizeCategory, .extraLarge)
                .preferredColorScheme(.dark)
        }
    }
}
```

Command line:
```bash
# Run with large text
xcrun simctl spawn booted defaults write -g com.apple.UIKit.ForcedSize "(1920, 1080)"
```

## Dark Mode Support

### Testing Dark Mode

In Xcode Previews:
```swift
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .preferredColorScheme(.light)
                .environment(\.colorScheme, .light)
            
            HomeView()
                .preferredColorScheme(.dark)
                .environment(\.colorScheme, .dark)
        }
    }
}
```

### Color Implementation

```swift
// Use semantic colors that adapt to scheme
Color(.label)  // Text
Color(.systemBackground)  // Backgrounds
Color(.systemBlue)  // Actions

// Or use custom tokens from design system
let textColor = Color(UIColor { traits in
    traits.userInterfaceStyle == .dark 
        ? UIColor.white 
        : UIColor.black
})
```

## Testing Accessibility

### Manual Testing

1. **Enable VoiceOver**: Settings > Accessibility > VoiceOver > On
2. **Test Navigation**: Swipe right/left to navigate, double-tap to activate
3. **Test Custom Actions**: Two-finger Z-gesture to see custom actions
4. **Test Zoom**: Settings > Accessibility > Zoom > On, double-tap with two fingers to zoom

### Automated Testing

```swift
import XCTest

final class AccessibilityTests: XCTestCase {
    func testHomeViewContrast() {
        // Verify color contrast ratios
        let darkText = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        let whiteBackground = UIColor.white
        
        // Calculate and assert contrast ratio ≥ 4.5
        let contrast = contrastRatio(darkText, whiteBackground)
        XCTAssertGreaterThanOrEqual(contrast, 4.5)
    }
    
    func testVoiceOverLabels() {
        let app = XCUIApplication()
        app.launch()
        
        let scanButton = app.buttons["Quick Scan"]
        XCTAssertTrue(scanButton.exists)
        
        // Verify accessibility label
        XCTAssertEqual(scanButton.label, "Quick Scan")
    }
}
```

## Color Blindness Considerations

### Severity Indicators

Do not rely on color alone for severity levels:

```swift
// ✗ Avoid - color only
Text("High")
    .foregroundColor(.red)

// ✓ Correct - icon + color + text
HStack(spacing: 4) {
    Image(systemName: "exclamationmark.circle.fill")
    Text("High")
}
.foregroundColor(.red)
```

### Palette

- **Red**: #FF3B30 (High severity)
- **Orange**: #FF9500 (Medium severity)
- **Green**: #34C759 (Low severity)
- **Blue**: #0A84FF (Info/neutral)

These colors are distinguishable for color-blind users.

## Checklist

- [ ] All text has sufficient contrast (4.5:1 minimum)
- [ ] All interactive elements are at least 44x44pt
- [ ] VoiceOver labels are clear and concise
- [ ] VoiceOver hints explain complex interactions
- [ ] App works with keyboard navigation
- [ ] No unexpected context changes on focus
- [ ] Error messages are clear and actionable
- [ ] Dynamic Type is supported (Small to ExtraLarge)
- [ ] Dark mode is fully functional
- [ ] Color is not the only way to convey meaning
- [ ] Confirmation dialogs for destructive actions
- [ ] Custom views include accessibility traits

## Resources

- [Apple Accessibility Documentation](https://developer.apple.com/accessibility/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [iOS Accessibility Tips](https://developer.apple.com/videos/accessibility/)
- [Accessibility Inspector Guide](https://developer.apple.com/videos/play/wwdc2021/10042/)
