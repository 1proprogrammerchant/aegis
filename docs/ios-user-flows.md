# iOS App User Flows & Acceptance Criteria

This document defines the key user flows and acceptance criteria for the Aegis iOS app.

## User Flows

### 1. Onboarding Flow

**Objective**: Get new users started with the app safely and educationally.

```
START
  ↓
Welcome Screen
  ├─ App description
  ├─ Privacy promise
  ├─ Feature overview
  ├─ [Next] → 
  │
Permissions Screen
  ├─ Request File Access
  ├─ Request Notifications
  ├─ [Continue] →
  │
Download Rulepacks
  ├─ Check for latest rulepacks
  ├─ Download & install
  ├─ [Ready] →
  │
Home Screen
  └─ Ready to scan
END
```

**Duration**: < 2 minutes  
**Success Metric**: User can start Quick Scan  
**Error Handling**: Show clear messages if permissions denied

### 2. Quick Scan Flow

**Objective**: Scan device quickly and show results.

```
START (User at Home Screen)
  ↓
User taps "Quick Scan"
  ├─ UI shows loading indicator
  ├─ Backend scans standard locations:
  │  ├─ /Documents
  │  ├─ /Downloads
  │  ├─ /Temporary
  │  └─ Recent app cache
  │
Scan completes (or user cancels)
  ├─ Results displayed:
  │  ├─ High: Red badge (danger)
  │  ├─ Medium: Orange badge (warning)
  │  └─ Low: Green badge (info)
  │
User sees results:
  ├─ Option 1: View details → Detail Screen
  ├─ Option 2: Quarantine → Item moved to Quarantine
  ├─ Option 3: Ignore → Result dismissed
  └─ Option 4: Report → Send to Aegis backend (optional)
END
```

**Duration**: 5-30 seconds (depending on storage)  
**Success Metrics**:
- Scan completes without crashing
- Results display correctly
- User can take action on items

### 3. View Scan Results Flow

**Objective**: Let user examine threat details.

```
START (From Home or dedicated Results screen)
  ↓
User sees results list
  ├─ Sorted by severity (High → Low)
  ├─ Filterable by severity
  │
User taps a result
  ↓
Detail Screen shows:
  ├─ Filename & path
  ├─ Rule matched
  ├─ Evidence (why it matched)
  ├─ Recommendation
  │
User can:
  ├─ Quarantine → Move to Quarantine
  ├─ Ignore → Dismiss finding (but keep in history)
  ├─ Report → Send to Aegis backend
  └─ Share → Share result with admin/support
END
```

**Interactions**:
- Tap on result → Detail view
- Swipe to quarantine (optional)
- Long-press for quick actions menu

### 4. Quarantine Management Flow

**Objective**: Manage quarantined files safely.

```
START (User navigates to Quarantine tab)
  ↓
Quarantine Screen shows:
  ├─ Empty state if no items
  │  └─ "All clear - your device is clean"
  │
  └─ List of items if populated
     ├─ Filename, threat type, days quarantined
     │
User can:
  ├─ Tap item → Detail view
  │  ├─ Shows original scan info
  │  ├─ Restore option (move back to original path)
  │  ├─ Delete permanently option
  │  └─ Report option
  │
  ├─ Swipe to delete (with confirmation)
  │
  ├─ Swipe to restore (with confirmation)
  │
  └─ Search/filter by name or type
END
```

**Safety Considerations**:
- Confirmation dialog for restore/delete
- Clear warning about permanent deletion
- Show original threat severity
- Suggest safer action if available

### 5. Rulepack Update Flow

**Objective**: Keep threat definitions current.

```
START (User navigates to Rulepacks)
  ↓
Rulepack Manager shows:
  ├─ Current version (e.g., "1.0.0")
  ├─ Last update date
  ├─ Rule count
  │
Automatic Check (on app launch):
  ├─ If update available → Notify user
  ├─ Auto-download in background (optional)
  │
User can:
  ├─ Tap "Check for Updates" button
  │  ├─ Connects to server
  │  ├─ Downloads latest rulepack (if available)
  │  ├─ Shows "Up to date" or progress
  │  └─ Installs automatically or prompts user
  │
  ├─ View version history
  │  ├─ Shows past versions with release dates
  │  ├─ Can downgrade if needed (caution)
  │
  └─ Manual install
     ├─ User selects file from Files app
     ├─ Validates rulepack signature
     ├─ Confirms before installing
END
```

**Notification Triggers**:
- New rulepack available
- Update completed
- Signature validation failed (error)

### 6. Scheduled Scan Flow

**Objective**: Run scans automatically at user-defined times.

```
START (User navigates to Settings)
  ↓
Scheduled Scans section:
  ├─ Toggle "Enable Scheduled Scans"
  ├─ Pick frequency (Daily, Weekly, Monthly)
  ├─ Pick time (default 2:00 AM)
  ├─ Pick scan type (Quick, Full)
  │
When scheduled time arrives:
  ├─ Check if device is plugged in
  ├─ Check if screen is locked
  ├─ Start background scan
  ├─ Collect results
  │
After scan:
  ├─ Notify user if threats found
  │  └─ Tap notification → Results screen
  ├─ Or silent completion if nothing found
  │
User can:
  ├─ Disable scheduled scans anytime
  ├─ Manually trigger immediate scan
  └─ View scheduled scan history
END
```

**Constraints**:
- Only run when plugged in (option)
- Only run with screen locked (privacy)
- Pause if thermal limit exceeded
- Allow user override

### 7. Settings & Preferences Flow

**Objective**: Let user customize app behavior.

```
START (User opens Settings)
  ↓
Settings Sections:
  │
  ├─ Scanning
  │  ├─ Scheduled Scans toggle
  │  ├─ Background Monitoring toggle
  │  ├─ Scan on app open toggle
  │  └─ Scan frequency
  │
  ├─ Privacy & Data
  │  ├─ Send threat reports (opt-in)
  │  ├─ Send usage analytics (opt-in)
  │  └─ Data retention policy
  │
  ├─ Notifications
  │  ├─ Alert on threats toggle
  │  ├─ Alert on scan completion toggle
  │  ├─ Sound on/off
  │  └─ Vibration on/off
  │
  ├─ Text Size
  │  ├─ Dynamic Type slider
  │  └─ Preview
  │
  ├─ About
  │  ├─ App version
  │  ├─ Engine version
  │  ├─ Privacy policy link
  │  ├─ Terms of service link
  │  └─ Contact support
  │
  └─ Danger Zone
     ├─ Clear all scan history
     ├─ Clear quarantine
     └─ Reset to defaults
END
```

**Persistence**:
- Settings saved immediately
- Cloud sync optional (enterprise)
- Respect system settings (Reduce Motion, etc.)

## Acceptance Criteria

### Home Screen

**Given** user opens the app  
**When** home screen loads  
**Then**:
- [ ] App name "Aegis" displays at top
- [ ] Current status shows (e.g., "Device Secure")
- [ ] "Quick Scan" button is prominent and tappable
- [ ] "Quarantine" button shows count badge (if items exist)
- [ ] "Rulepacks" button navigates to manager
- [ ] Last scan date displays
- [ ] Recent findings show in list (max 3)
- [ ] "View all findings" link appears if > 3 items
- [ ] All elements have accessibility labels
- [ ] Light and dark modes render correctly
- [ ] Dynamic Type size variations work

### Quick Scan

**Given** user taps "Quick Scan"  
**When** scan is in progress  
**Then**:
- [ ] Loading indicator displays
- [ ] UI shows "Scanning..."
- [ ] User can still navigate (scan in background)
- [ ] User can cancel scan
- [ ] "Quick Scan" button disabled until complete

**When** scan completes  
**Then**:
- [ ] Loading indicator disappears
- [ ] Results display immediately
- [ ] Each result shows filename, severity, rule matched
- [ ] Severity badges use correct colors
- [ ] Results sorted by severity (high first)
- [ ] No results show green checkmark
- [ ] Threatening results show appropriate icon

### Scan Results

**Given** user views scan results  
**When** results load  
**Then**:
- [ ] Results count displays ("5 findings")
- [ ] Results filtered/sorted correctly
- [ ] Each result is tappable
- [ ] Each result shows:
  - [ ] Filename
  - [ ] Severity badge
  - [ ] Brief description
  - [ ] Quick action (quarantine icon)

**When** user taps a result  
**Then**:
- [ ] Detail view opens
- [ ] Full details display:
  - [ ] Filename and path
  - [ ] Rule matched
  - [ ] Evidence/reason
  - [ ] Recommendation
- [ ] User can quarantine from detail view
- [ ] User can go back to results

### Quarantine

**Given** user navigates to Quarantine  
**When** no items in quarantine  
**Then**:
- [ ] Empty state message displays
- [ ] "All clear" icon shows
- [ ] Can navigate back home

**Given** user has quarantined items  
**When** Quarantine screen loads  
**Then**:
- [ ] Items list displays
- [ ] Each item shows:
  - [ ] Filename
  - [ ] Severity indicator
  - [ ] Days quarantined
  - [ ] Quick action menu
- [ ] User can restore item (with confirmation)
- [ ] User can delete item permanently (with warning)
- [ ] Search/filter works

### Settings

**Given** user opens Settings  
**When** Settings screen loads  
**Then**:
- [ ] All toggle switches render
- [ ] All toggles work (on/off)
- [ ] Settings persist after close/reopen
- [ ] Links open in Safari (privacy policy, etc.)
- [ ] Text size controls affect preview

### Rulepacks

**Given** user navigates to Rulepacks  
**When** screen loads  
**Then**:
- [ ] Current version displays
- [ ] Last update date shows
- [ ] Rule count displays
- [ ] "Check for Updates" button exists
- [ ] Version history list appears
- [ ] Each version shows:
  - [ ] Version number
  - [ ] Release date
  - [ ] Update status icon

**Given** user taps "Check for Updates"  
**When** check is in progress  
**Then**:
- [ ] Button shows loading state
- [ ] User can wait or dismiss

**When** check completes  
**Then**:
- [ ] Result displays (up to date or update available)
- [ ] If update available, offer to install
- [ ] If update installed, show confirmation

### Accessibility

**Given** VoiceOver is enabled  
**When** user navigates the app  
**Then**:
- [ ] All buttons have labels
- [ ] All icons have descriptions
- [ ] Custom actions available for common tasks
- [ ] Focus order is logical
- [ ] No keyboard traps exist
- [ ] Lists are navigable
- [ ] Form fields have labels

**Given** Dynamic Type is set to Large or ExtraLarge  
**When** app renders  
**Then**:
- [ ] Text remains readable
- [ ] No text truncation
- [ ] Buttons remain tappable
- [ ] Layout adapts (no horizontal scroll needed)
- [ ] All interactive elements sized appropriately

**Given** app is in Dark Mode  
**When** user navigates screens  
**Then**:
- [ ] All colors are correctly inverted
- [ ] Text has sufficient contrast
- [ ] Badges/indicators visible
- [ ] No black text on dark backgrounds
- [ ] Images have dark mode variants where needed

### Performance

**Given** user initiates Quick Scan  
**When** scan runs  
**Then**:
- [ ] Scan completes in < 30 seconds (standard device)
- [ ] UI remains responsive (60 FPS scrolling)
- [ ] Memory usage stays < 150 MB

**Given** large results set (100+ items)  
**When** results screen loads and user scrolls  
**Then**:
- [ ] Scrolling is smooth (60 FPS)
- [ ] No apparent lag
- [ ] App doesn't crash

**Given** app is running  
**When** scheduled scan completes  
**Then**:
- [ ] Battery drain minimal
- [ ] No thermal issues
- [ ] Background operation clean

### Error Handling

**Given** network is unavailable  
**When** user tries to check for rulepack updates  
**Then**:
- [ ] Clear error message shows
- [ ] Actionable suggestion provided
- [ ] User can retry

**Given** no rulepack is installed  
**When** user tries to scan  
**Then**:
- [ ] Clear error message shows
- [ ] Link to install rulepacks provided
- [ ] Scan is blocked (safe to prevent false results)

**Given** file permissions are denied  
**When** user initiates scan  
**Then**:
- [ ] Error message explains permission needed
- [ ] Link to Settings provided
- [ ] Clear instructions on how to grant permission

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Time to Quick Scan | < 30s | User stopwatch |
| UI Responsiveness | 60 FPS | Xcode Instruments |
| Memory Usage | < 150 MB | Xcode profiler |
| Crash Rate | < 0.1% | Analytics |
| App Store Rating | > 4.5 stars | App Store reviews |
| Accessibility Score | > 95% | Automated audit |
| Coverage | > 85% | Test suite |

## Sign-Off Checklist

- [ ] All user flows documented and walked through
- [ ] Acceptance criteria verified by QA
- [ ] Accessibility audit completed
- [ ] Performance benchmarks met
- [ ] Error scenarios tested
- [ ] Ready for beta testing
- [ ] Ready for App Store submission

---

**Version**: 1.0  
**Last Updated**: 2026-07-06  
**Maintained by**: Aegis Team
