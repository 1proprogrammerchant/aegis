# Aegis iOS Design System

A privacy-first, accessible design system for the Aegis antivirus iOS app. Built with SwiftUI and designed for clarity, trust, and user control.

## Design Principles

1. **Privacy-First** - Clear, honest communication about scanning and data handling
2. **Accessible** - WCAG AA compliant with support for VoiceOver and Dynamic Type
3. **Consistent** - Unified component library and token-based styling
4. **Dark Mode** - Full support for both light and dark appearances
5. **User-Focused** - Approachable for non-technical users, powerful for administrators

## Color System

### Light Theme (Default)

| Token | Value | Usage |
|-------|-------|-------|
| `primary` | #0A84FF | Primary actions, links, active states |
| `primaryVariant` | #0051D5 | Primary actions (pressed state) |
| `background` | #FFFFFF | App background |
| `surface` | #F2F2F7 | Card, sheet, and panel backgrounds |
| `surfaceVariant` | #E5E5EA | Secondary surface backgrounds |
| `text` | #1C1C1E | Primary text color |
| `textSecondary` | #8E8E93 | Secondary/disabled text |
| `textTertiary` | #C7C7CC | Tertiary/hint text |
| `border` | #E5E5EA | Border and divider colors |
| `danger` | #FF3B30 | High severity, critical errors |
| `dangerLight` | #FFE5E1 | Danger background (subtle) |
| `success` | #34C759 | Low severity, success states |
| `successLight` | #E1F5E1 | Success background (subtle) |
| `warning` | #FF9500 | Medium severity, warnings |
| `warningLight` | #FFF3E0 | Warning background (subtle) |

### Dark Theme

| Token | Value | Usage |
|-------|-------|-------|
| `primary` | #0A84FF | Primary actions, links, active states |
| `primaryVariant` | #54B3FF | Primary actions (alternative) |
| `background` | #000000 | App background |
| `surface` | #1C1C1E | Card, sheet, and panel backgrounds |
| `surfaceVariant` | #2C2C2E | Secondary surface backgrounds |
| `text` | #FFFFFF | Primary text color |
| `textSecondary` | #8E8E93 | Secondary/disabled text |
| `textTertiary` | #434345 | Tertiary/hint text |
| `border` | #3A3A3C | Border and divider colors |
| `danger` | #FF453A | High severity, critical errors |
| `dangerLight` | #2C1115 | Danger background (subtle) |
| `success` | #30B0C0 | Low severity, success states |
| `successLight` | #0D2E2E | Success background (subtle) |

## Severity Indicators

| Severity | Color | Background | Icon | Usage |
|----------|-------|-----------|------|-------|
| **High** | `danger` | `dangerLight` | ⚠️ | Critical threats, malware |
| **Medium** | `warning` | `warningLight` | ⚠️ | Suspicious files, trackers |
| **Low** | `success` | `successLight` | ℹ️ | Minor concerns, info |

## Typography

### Font Families

- **Primary**: San Francisco (system default)
- **Fallback**: -apple-system (iOS 11+)

### Type Scale

| Token | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `h1` | 28pt | 700 | 1.2 | Screen titles, hero text |
| `h2` | 22pt | 600 | 1.3 | Section headers, card titles |
| `h3` | 18pt | 600 | 1.3 | Subsection headers |
| `body` | 17pt | 400 | 1.5 | Primary body text |
| `bodySmall` | 15pt | 400 | 1.5 | Secondary body text |
| `caption` | 13pt | 400 | 1.4 | Labels, captions, hints |
| `captionSmall` | 12pt | 400 | 1.4 | Badges, metadata |

### Accessibility

- Support Dynamic Type with size categories: Small, Large, and ExtraLarge
- Use `.lineLimit` with caution; prefer wrapping text
- Scale typography proportionally in accessibility mode

## Spacing & Layout

### Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4pt | Micro spacing (tight groups) |
| `sm` | 8pt | Small spacing (components) |
| `md` | 16pt | Medium spacing (standard padding) |
| `lg` | 24pt | Large spacing (section spacing) |
| `xl` | 32pt | Extra large spacing (major sections) |
| `xxl` | 48pt | Double extra large (full-screen sections) |

### Safe Areas

- Respect safe areas on notched and home-indicator devices
- Minimum edge padding: `md` (16pt)
- Keep interactive elements at least 44x44pt (minimum tap target)

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `small` | 8pt | Buttons, badges, small components |
| `medium` | 12pt | Cards, sheets |
| `large` | 16pt | Larger cards, modal backgrounds |
| `full` | 24pt | Fully rounded components (avatars, etc.) |

## Shadows & Elevation

| Token | Offset | Blur Radius | Opacity | Usage |
|-------|--------|------------|---------|-------|
| `small` | 2pt | 4pt | 10% | Subtle elevation |
| `medium` | 4pt | 8pt | 15% | Standard elevation |
| `large` | 8pt | 16pt | 20% | Strong elevation (modals) |

## Component Library

### Button

**States**: Default, Pressed, Disabled, Loading

```swift
Button(action: {}) {
    Text("Scan Now")
        .font(.system(.body, design: .default).weight(.semibold))
}
.padding(.vertical, 12)
.padding(.horizontal, 16)
.background(Color.blue)
.foregroundColor(.white)
.cornerRadius(8)
.disabled(false)
```

**Accessibility**:
- Add `.accessibility(label:)` for button purpose
- Add `.accessibility(hint:)` for additional context
- Use `.isEnabled` state for disabled buttons

### Card

**Anatomy**: Background, content, optional action, optional metadata

```swift
VStack(alignment: .leading, spacing: 12) {
    HStack {
        Text("Card Title").font(.headline)
        Spacer()
        Text("Metadata").font(.caption).foregroundColor(.secondary)
    }
    Text("Card content goes here.")
        .font(.body)
        .foregroundColor(.secondary)
}
.padding(16)
.background(Color.surface)
.cornerRadius(12)
```

### Severity Badge

**States**: High, Medium, Low

```swift
HStack(spacing: 8) {
    Image(systemName: "exclamationmark.circle.fill")
    Text("High").font(.captionSmall).fontWeight(.semibold)
}
.foregroundColor(severity.color)
.padding(.vertical, 6)
.padding(.horizontal, 10)
.background(severity.backgroundColor)
.cornerRadius(6)
```

### List Item (Scan Result)

```swift
HStack(spacing: 12) {
    VStack(alignment: .leading, spacing: 4) {
        Text("filename.pdf").font(.headline)
        Text("Details...").font(.caption).foregroundColor(.secondary)
    }
    Spacer()
    SeverityBadge(severity: .high)
}
.padding(12)
.background(Color.surface)
.cornerRadius(12)
```

### Action Sheet / Modal

- Use `.sheet()` for temporary modals
- Use `.confirmationDialog()` for critical actions
- Always include clear "Cancel" and action buttons
- Restore state if user dismisses without action

## Animations & Transitions

- **Fade**: 300ms (state changes)
- **Scale**: 200ms (button press, collapse/expand)
- **Slide**: 300ms (navigation, sheet dismissal)

Use Spring animation for natural feel:
```swift
.spring(response: 0.3, dampingFraction: 0.7)
```

## Dark Mode Implementation

```swift
@Environment(\.colorScheme) var colorScheme

// Use:
let textColor = colorScheme == .dark ? Color.white : Color.black

// Or use semantic colors:
let textColor = Color(UIColor { traits in
    traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
})
```

## Accessibility Standards

### WCAG AA Compliance

- **Color Contrast**: Minimum 4.5:1 for text, 3:1 for large text
- **Touch Target Size**: Minimum 44x44pt
- **Focus Indicator**: Clear visual focus state
- **Error Messages**: Clear, actionable text

### VoiceOver Support

Add labels to all interactive elements:

```swift
Button(action: {}) {
    Image(systemName: "arrow.clockwise")
}
.accessibility(label: Text("Refresh"))
.accessibility(hint: Text("Reloads the scan results"))
```

### Dynamic Type Support

```swift
Text("Title")
    .font(.system(.title, design: .default))
    .dynamicTypeSize(...) // Optional constraint
```

## Screen Specifications

### Home / Status Screen

- **Header**: App name, current status, last scan time
- **Actions**: Quick Scan button (prominent), Scheduled Scan toggle
- **Content**: Recent results list with severity indicators
- **Navigation**: Tab bar to Quarantine, Settings, Rulepack Manager

### Scan Results Screen

- **Header**: Scan time, item count, status (completed/in progress)
- **Content**: Filterable list (High/Medium/Low severity)
- **Item Detail**: Filename, rule matched, evidence, recommendation
- **Actions**: Quarantine, Ignore, Report, Delete

### Quarantine Screen

- **List**: Quarantined items with restore/delete actions
- **Detail**: Item info, scan date, reason for quarantine
- **Actions**: Restore, Delete Permanently, Report

### Settings Screen

- **Sections**: 
  - Scanning (automatic scanning, scheduling)
  - Privacy (data collection, updates)
  - About (app version, attributions)
- **Accessibility Controls**: Text size, VoiceOver settings

### Rulepack Manager Screen

- **Header**: Current rulepack version, update date
- **Actions**: Check for Updates, Manual Install
- **Content**: Version history, update notes
- **Status**: Update in progress indicator

## Next Steps

1. **Figma Design File**: Import SVG components and tokens into a shared Figma workspace
2. **Implementation**: Use SwiftUI to build components matching this spec
3. **Testing**: Validate accessibility, dark mode, and Dynamic Type support
4. **Review**: Iterate based on user feedback and usability testing

## Resources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [iOS Design Resources](https://developer.apple.com/design/resources/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Apple Accessibility Documentation](https://developer.apple.com/accessibility/)
