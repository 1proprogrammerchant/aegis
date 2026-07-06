import SwiftUI

/// Home screen showing app status and scan controls
struct EnhancedHomeView: View {
    @State private var isScanning = false
    @State private var lastScanResults: [ScanResult] = []
    @State private var appStatus = AppStatus(
        rulepackVersion: "1.0.0",
        engineVersion: "1.0.0",
        quarantineItemCount: 0,
        threatsDetected: 0,
        isScanInProgress: false,
        scheduledScansEnabled: true,
        backgroundScanEnabled: true
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.aegisBackground.ignoresSafeArea()
                
                if isScanning {
                    LoadingIndicator()
                } else {
                    ScrollView {
                        VStack(spacing: AegisSpacing.lg) {
                            // Header with status
                            VStack(alignment: .leading, spacing: AegisSpacing.md) {
                                HStack {
                                    VStack(alignment: .leading, spacing: AegisSpacing.sm) {
                                        Text("Aegis")
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.aegisText)
                                        
                                        HStack(spacing: AegisSpacing.xs) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.aegisSuccess)
                                            
                                            Text("Device Secure")
                                                .font(.system(size: 13))
                                                .foregroundColor(.aegisTextSecondary)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: SettingsView()) {
                                        Image(systemName: "gear")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.aegisPrimary)
                                            .frame(width: 44, height: 44)
                                    }
                                    .accessibility(label: Text("Settings"))
                                }
                            }
                            .padding(AegisSpacing.md)
                            .background(Color.aegisSurface)
                            .cornerRadius(AegisBorderRadius.medium)
                            .padding(.horizontal, AegisSpacing.md)
                            
                            // Quick action buttons
                            VStack(spacing: AegisSpacing.md) {
                                PrimaryButton(title: "Quick Scan", isLoading: isScanning, action: {
                                    performQuickScan()
                                })
                                
                                NavigationLink(destination: QuarantineView()) {
                                    HStack {
                                        Image(systemName: "lock.box.fill")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text("Quarantine")
                                            .font(.system(.body, design: .default).weight(.semibold))
                                        Spacer()
                                        if appStatus.quarantineItemCount > 0 {
                                            Text("\(appStatus.quarantineItemCount)")
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.white)
                                                .frame(width: 24, height: 24)
                                                .background(Color.aegisWarning)
                                                .cornerRadius(4)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .foregroundColor(.white)
                                    .background(Color.aegisSurface.opacity(0.8))
                                    .cornerRadius(AegisBorderRadius.small)
                                }
                                .accessibility(label: Text("Quarantine"))
                                
                                NavigationLink(destination: RulepackManagerView()) {
                                    HStack {
                                        Image(systemName: "doc.text.fill")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text("Rulepacks")
                                            .font(.system(.body, design: .default).weight(.semibold))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .foregroundColor(.aegisText)
                                    .background(Color.aegisSurface.opacity(0.8))
                                    .cornerRadius(AegisBorderRadius.small)
                                }
                                .accessibility(label: Text("Rulepacks"))
                            }
                            .padding(.horizontal, AegisSpacing.md)
                            
                            // Status cards
                            VStack(spacing: AegisSpacing.md) {
                                StatusCard(
                                    title: "Threats Found",
                                    value: "\(appStatus.threatsDetected)",
                                    icon: "exclamationmark.circle",
                                    color: appStatus.threatsDetected > 0 ? .aegisDanger : .aegisSuccess
                                )
                                
                                StatusCard(
                                    title: "Rulepack Version",
                                    value: appStatus.rulepackVersion,
                                    icon: "doc.text",
                                    color: .aegisInfo
                                )
                                
                                if let lastScanDate = appStatus.lastScanDate {
                                    StatusCard(
                                        title: "Last Scan",
                                        value: formatDate(lastScanDate),
                                        icon: "clock",
                                        color: .aegisPrimary,
                                        subtitle: timeAgo(from: lastScanDate)
                                    )
                                }
                            }
                            .padding(.horizontal, AegisSpacing.md)
                            
                            // Recent results section
                            if !lastScanResults.isEmpty {
                                VStack(alignment: .leading, spacing: AegisSpacing.md) {
                                    SectionHeader(title: "Recent Findings", subtitle: "\(lastScanResults.count) items")
                                    
                                    VStack(spacing: AegisSpacing.sm) {
                                        ForEach(lastScanResults.prefix(3)) { result in
                                            NavigationLink(destination: ScanResultDetailView(result: result)) {
                                                ScanResultItem(
                                                    result: result,
                                                    onTap: {},
                                                    onQuarantine: { quarantineResult(result) }
                                                )
                                            }
                                        }
                                    }
                                    
                                    if lastScanResults.count > 3 {
                                        NavigationLink(destination: ScanResultsView(results: lastScanResults)) {
                                            HStack {
                                                Text("View all \(lastScanResults.count) findings")
                                                    .font(.system(.body, design: .default).weight(.semibold))
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                            }
                                            .foregroundColor(.aegisPrimary)
                                            .padding(AegisSpacing.md)
                                        }
                                    }
                                }
                                .padding(.horizontal, AegisSpacing.md)
                            } else {
                                VStack(spacing: AegisSpacing.md) {
                                    SectionHeader(title: "Recent Findings", subtitle: "None yet")
                                    
                                    EmptyStateView(
                                        icon: "checkmark.circle",
                                        title: "All Clear",
                                        message: "No threats detected. Run a scan to check your device."
                                    )
                                }
                            }
                            
                            Spacer(minLength: AegisSpacing.xl)
                        }
                        .padding(.vertical, AegisSpacing.md)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadAppStatus()
        }
    }
    
    // MARK: - Actions
    
    private func performQuickScan() {
        isScanning = true
        
        // Simulate scan
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            lastScanResults = [
                ScanResult(
                    id: UUID(),
                    filename: "suspicious_file.pdf",
                    filepath: "/Documents/suspicious_file.pdf",
                    detail: "Matched rule 'malware_pdf_exploit'",
                    severity: .high,
                    ruleMatched: "malware_pdf_exploit",
                    evidence: "Suspicious JavaScript in PDF",
                    recommendation: "Move to Quarantine or delete",
                    timestamp: Date()
                ),
                ScanResult(
                    id: UUID(),
                    filename: "tracking_pixel.gif",
                    filepath: "/Downloads/tracking_pixel.gif",
                    detail: "Low-risk tracker detection",
                    severity: .low,
                    ruleMatched: "tracking_pixel",
                    evidence: "Known tracking service domain",
                    recommendation: "Can be safely ignored",
                    timestamp: Date()
                )
            ]
            appStatus.threatsDetected = 1
            appStatus.lastScanDate = Date()
            isScanning = false
        }
    }
    
    private func quarantineResult(_ result: ScanResult) {
        appStatus.quarantineItemCount += 1
    }
    
    private func loadAppStatus() {
        // Load from persistent storage or API
        appStatus.lastScanDate = Date().addingTimeInterval(-3600)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    private func timeAgo(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .day, .minute], from: date, to: Date())
        
        if let day = components.day, day > 0 {
            return "\(day) day\(day > 1 ? "s" : "") ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour > 1 ? "s" : "") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute > 1 ? "s" : "") ago"
        }
        return "Just now"
    }
}

// MARK: - Placeholder Views

struct ScanResultsView: View {
    let results: [ScanResult]
    @State private var selectedSeverity: Severity? = nil
    
    var filteredResults: [ScanResult] {
        if let severity = selectedSeverity {
            return results.filter { $0.severity == severity }
        }
        return results
    }
    
    var body: some View {
        ZStack {
            Color.aegisBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: AegisSpacing.md) {
                    HStack {
                        Text("Scan Results")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.aegisText)
                        Spacer()
                    }
                    
                    Text("\(filteredResults.count) findings")
                        .font(.system(size: 13))
                        .foregroundColor(.aegisTextSecondary)
                }
                .padding(AegisSpacing.md)
                
                ScrollView {
                    VStack(spacing: AegisSpacing.sm) {
                        ForEach(filteredResults) { result in
                            NavigationLink(destination: ScanResultDetailView(result: result)) {
                                ScanResultItem(
                                    result: result,
                                    onTap: {},
                                    onQuarantine: {}
                                )
                            }
                        }
                    }
                    .padding(AegisSpacing.md)
                }
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScanResultDetailView: View {
    let result: ScanResult
    @State private var isQuarantined = false
    
    var body: some View {
        ZStack {
            Color.aegisBackground.ignoresSafeArea()
            
            VStack(spacing: AegisSpacing.lg) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AegisSpacing.lg) {
                        // Severity badge
                        HStack {
                            SeverityBadge(severity: result.severity)
                            Spacer()
                        }
                        
                        // File info
                        VStack(alignment: .leading, spacing: AegisSpacing.md) {
                            Text("File Details")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.aegisText)
                            
                            VStack(alignment: .leading, spacing: AegisSpacing.sm) {
                                HStack {
                                    Text("Filename")
                                        .foregroundColor(.aegisTextSecondary)
                                    Spacer()
                                    Text(result.filename)
                                        .foregroundColor(.aegisText)
                                        .lineLimit(1)
                                }
                                
                                HStack {
                                    Text("Path")
                                        .foregroundColor(.aegisTextSecondary)
                                    Spacer()
                                    Text(result.filepath)
                                        .foregroundColor(.aegisText)
                                        .font(.system(size: 12, design: .monospaced))
                                        .lineLimit(1)
                                }
                                
                                HStack {
                                    Text("Rule Matched")
                                        .foregroundColor(.aegisTextSecondary)
                                    Spacer()
                                    Text(result.ruleMatched)
                                        .foregroundColor(.aegisText)
                                        .lineLimit(1)
                                }
                            }
                            .padding(AegisSpacing.md)
                            .background(Color.aegisSurface)
                            .cornerRadius(AegisBorderRadius.small)
                        }
                        
                        // Evidence
                        VStack(alignment: .leading, spacing: AegisSpacing.sm) {
                            Text("Evidence")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.aegisText)
                            
                            Text(result.evidence)
                                .font(.system(size: 13))
                                .foregroundColor(.aegisTextSecondary)
                                .padding(AegisSpacing.md)
                                .background(Color.aegisSurface)
                                .cornerRadius(AegisBorderRadius.small)
                        }
                        
                        // Recommendation
                        VStack(alignment: .leading, spacing: AegisSpacing.sm) {
                            Text("Recommended Action")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.aegisText)
                            
                            AlertBadge(message: result.recommendation, type: .warning)
                        }
                    }
                    .padding(AegisSpacing.md)
                }
                
                // Actions
                VStack(spacing: AegisSpacing.sm) {
                    if !isQuarantined {
                        PrimaryButton(title: "Quarantine", action: {
                            isQuarantined = true
                        })
                        
                        SecondaryButton(title: "Ignore", action: {})
                    } else {
                        AlertBadge(message: "File moved to Quarantine", type: .info)
                    }
                }
                .padding(AegisSpacing.md)
            }
        }
        .navigationTitle(result.filename)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuarantineView: View {
    @State private var quarantineItems: [QuarantineItem] = []
    
    var body: some View {
        ZStack {
            Color.aegisBackground.ignoresSafeArea()
            
            if quarantineItems.isEmpty {
                EmptyStateView(
                    icon: "lock.open",
                    title: "Quarantine Empty",
                    message: "No items in quarantine. Your device is clean."
                )
            } else {
                VStack(spacing: 0) {
                    Text("Quarantine")
                        .font(.system(size: 28, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AegisSpacing.md)
                    
                    ScrollView {
                        VStack(spacing: AegisSpacing.sm) {
                            ForEach(quarantineItems) { item in
                                HStack(spacing: AegisSpacing.md) {
                                    VStack(alignment: .leading, spacing: AegisSpacing.xs) {
                                        Text(item.filename)
                                            .font(.system(.headline))
                                            .foregroundColor(.aegisText)
                                        
                                        Text("Quarantined \(item.daysQuarantined) days ago")
                                            .font(.system(size: 12))
                                            .foregroundColor(.aegisTextSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("Restore", action: {})
                                        Button("Delete", role: .destructive, action: {})
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.aegisPrimary)
                                    }
                                }
                                .padding(AegisSpacing.md)
                                .background(Color.aegisSurface)
                                .cornerRadius(AegisBorderRadius.small)
                            }
                        }
                        .padding(AegisSpacing.md)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SettingsView: View {
    @State private var schedulingEnabled = true
    @State private var backgroundScanEnabled = true
    
    var body: some View {
        ZStack {
            Color.aegisBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AegisSpacing.md)
                
                ScrollView {
                    VStack(spacing: AegisSpacing.lg) {
                        VStack(alignment: .leading, spacing: AegisSpacing.md) {
                            Text("Scanning")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.aegisText)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: AegisSpacing.xs) {
                                    Text("Scheduled Scans")
                                        .font(.system(.body))
                                        .foregroundColor(.aegisText)
                                    
                                    Text("Automatic daily scans at 2:00 AM")
                                        .font(.system(size: 13))
                                        .foregroundColor(.aegisTextSecondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $schedulingEnabled)
                            }
                            .padding(AegisSpacing.md)
                            .background(Color.aegisSurface)
                            .cornerRadius(AegisBorderRadius.small)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: AegisSpacing.xs) {
                                    Text("Background Scan")
                                        .font(.system(.body))
                                        .foregroundColor(.aegisText)
                                    
                                    Text("Monitors new downloads and changes")
                                        .font(.system(size: 13))
                                        .foregroundColor(.aegisTextSecondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $backgroundScanEnabled)
                            }
                            .padding(AegisSpacing.md)
                            .background(Color.aegisSurface)
                            .cornerRadius(AegisBorderRadius.small)
                        }
                        .padding(.horizontal, AegisSpacing.md)
                        
                        VStack(alignment: .leading, spacing: AegisSpacing.md) {
                            Text("About")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.aegisText)
                            
                            VStack(alignment: .leading, spacing: AegisSpacing.sm) {
                                HStack {
                                    Text("App Version")
                                        .foregroundColor(.aegisTextSecondary)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.aegisText)
                                }
                                
                                HStack {
                                    Text("Engine Version")
                                        .foregroundColor(.aegisTextSecondary)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.aegisText)
                                }
                            }
                            .padding(AegisSpacing.md)
                            .background(Color.aegisSurface)
                            .cornerRadius(AegisBorderRadius.small)
                        }
                        .padding(.horizontal, AegisSpacing.md)
                    }
                    .padding(.vertical, AegisSpacing.md)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct RulepackManagerView: View {
    @State private var currentVersion = "1.0.0"
    @State private var lastUpdateDate = Date()
    @State private var isCheckingForUpdates = false
    
    var body: some View {
        ZStack {
            Color.aegisBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Rulepacks")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AegisSpacing.md)
                
                ScrollView {
                    VStack(spacing: AegisSpacing.lg) {
                        StatusCard(
                            title: "Current Version",
                            value: currentVersion,
                            icon: "doc.text.fill",
                            color: .aegisPrimary,
                            subtitle: "Updated \(timeAgoString(lastUpdateDate)) ago"
                        )
                        .padding(.horizontal, AegisSpacing.md)
                        
                        VStack(spacing: AegisSpacing.md) {
                            PrimaryButton(
                                title: isCheckingForUpdates ? "Checking..." : "Check for Updates",
                                isLoading: isCheckingForUpdates,
                                action: { checkForUpdates() }
                            )
                            
                            SecondaryButton(title: "Manual Install", action: {})
                        }
                        .padding(.horizontal, AegisSpacing.md)
                        
                        VStack(alignment: .leading, spacing: AegisSpacing.md) {
                            Text("Version History")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.aegisText)
                                .padding(.horizontal, AegisSpacing.md)
                            
                            VStack(spacing: AegisSpacing.sm) {
                                ForEach(["1.0.0", "0.9.5", "0.9.0"], id: \.self) { version in
                                    HStack {
                                        VStack(alignment: .leading, spacing: AegisSpacing.xs) {
                                            Text("Version \(version)")
                                                .font(.system(.body, design: .default).weight(.semibold))
                                                .foregroundColor(.aegisText)
                                            
                                            Text("Released 30 days ago")
                                                .font(.system(size: 12))
                                                .foregroundColor(.aegisTextSecondary)
                                        }
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.aegisSuccess)
                                    }
                                    .padding(AegisSpacing.md)
                                    .background(Color.aegisSurface)
                                    .cornerRadius(AegisBorderRadius.small)
                                }
                            }
                            .padding(.horizontal, AegisSpacing.md)
                        }
                    }
                    .padding(.vertical, AegisSpacing.md)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func checkForUpdates() {
        isCheckingForUpdates = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isCheckingForUpdates = false
        }
    }
    
    private func timeAgoString(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.day], from: date, to: Date())
        let days = components.day ?? 0
        return days == 0 ? "Today" : "\(days)d"
    }
}

#if DEBUG
struct EnhancedHomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EnhancedHomeView()
                .preferredColorScheme(.light)
            
            EnhancedHomeView()
                .preferredColorScheme(.dark)
        }
    }
}
#endif
