import SwiftUI

// MARK: - Severity Badge Component

struct SeverityBadge: View {
    let severity: Severity
    
    var body: some View {
        HStack(spacing: AegisSpacing.sm) {
            Image(systemName: severity.icon)
                .font(.system(size: 12, weight: .semibold))
            Text(severity.rawValue)
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundColor(severity.color)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(severity.backgroundColor)
        .cornerRadius(AegisBorderRadius.small)
        .accessibility(label: Text("\(severity.rawValue) severity"))
    }
}

// MARK: - Scan Result List Item

struct ScanResultItem: View {
    let result: ScanResult
    let onTap: () -> Void
    let onQuarantine: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AegisSpacing.md) {
                VStack(alignment: .leading, spacing: AegisSpacing.sm) {
                    Text(result.filename)
                        .font(.system(.headline, design: .default))
                        .lineLimit(1)
                        .foregroundColor(.aegisText)
                    
                    Text(result.ruleMatched)
                        .font(.system(size: 13, design: .default))
                        .foregroundColor(.aegisTextSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AegisSpacing.xs) {
                    SeverityBadge(severity: result.severity)
                    
                    if !result.isQuarantined {
                        Button(action: onQuarantine) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 16))
                                .foregroundColor(.aegisPrimary)
                        }
                        .accessibility(label: Text("Quarantine"))
                        .accessibility(hint: Text("Move this file to quarantine"))
                    }
                }
            }
            .padding(AegisSpacing.md)
            .background(Color.aegisSurface)
            .cornerRadius(AegisBorderRadius.medium)
        }
        .accessibility(addTraits: .isButton)
        .accessibility(label: Text(result.filename))
        .accessibility(hint: Text("\(result.severity.rawValue) severity, rule: \(result.ruleMatched)"))
    }
}

// MARK: - Primary Action Button

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let isEnabled: Bool
    
    init(title: String, isLoading: Bool = false, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AegisSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .font(.system(.body, design: .default).weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .foregroundColor(.white)
            .background(isEnabled ? Color.aegisPrimary : Color.aegisPrimary.opacity(0.5))
            .cornerRadius(AegisBorderRadius.small)
        }
        .disabled(!isEnabled || isLoading)
        .accessibility(label: Text(title))
        .accessibility(hint: Text(isLoading ? "Loading" : ""))
    }
}

// MARK: - Secondary Button

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.body, design: .default).weight(.semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .foregroundColor(.aegisPrimary)
                .background(Color.aegisSurface)
                .cornerRadius(AegisBorderRadius.small)
                .overlay(
                    RoundedRectangle(cornerRadius: AegisBorderRadius.small)
                        .stroke(Color.aegisPrimary, lineWidth: 1)
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .accessibility(label: Text(title))
    }
}

// MARK: - Status Card

struct StatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let subtitle: String?
    
    init(title: String, value: String, icon: String, color: Color = .aegisPrimary, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AegisSpacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: AegisSpacing.xs) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.aegisTextSecondary)
                    
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.aegisText)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 12, design: .default))
                            .foregroundColor(.aegisTextTertiary)
                    }
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color.opacity(0.7))
            }
        }
        .padding(AegisSpacing.md)
        .background(Color.aegisSurface)
        .cornerRadius(AegisBorderRadius.medium)
        .accessibility(addTraits: .isStaticText)
        .accessibility(label: Text(title))
        .accessibility(value: Text(value))
    }
}

// MARK: - List Section Header

struct SectionHeader: View {
    let title: String
    let subtitle: String?
    
    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AegisSpacing.xs) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aegisText)
            
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 13, design: .default))
                    .foregroundColor(.aegisTextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AegisSpacing.md)
        .padding(.vertical, AegisSpacing.md)
        .accessibility(addTraits: .isHeader)
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let action: (() -> Void)?
    let actionTitle: String?
    
    init(icon: String, title: String, message: String, action: (() -> Void)? = nil, actionTitle: String? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
        self.action = action
        self.actionTitle = actionTitle
    }
    
    var body: some View {
        VStack(spacing: AegisSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.aegisTextTertiary)
            
            VStack(spacing: AegisSpacing.sm) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.aegisText)
                
                Text(message)
                    .font(.system(size: 15, design: .default))
                    .foregroundColor(.aegisTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let action, let actionTitle {
                PrimaryButton(title: actionTitle, action: action)
            }
        }
        .padding(AegisSpacing.xl)
        .frame(maxHeight: .infinity, alignment: .center)
        .accessibility(addTraits: .isStaticText)
        .accessibility(label: Text(title))
    }
}

// MARK: - Loading Indicator

struct LoadingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: AegisSpacing.md) {
            ProgressView()
                .tint(.aegisPrimary)
            
            Text("Scanning...")
                .font(.system(.body, design: .default))
                .foregroundColor(.aegisText)
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .accessibility(label: Text("Scanning"))
        .accessibility(hint: Text("Please wait while the scan is in progress"))
    }
}

// MARK: - Alert Badge

struct AlertBadge: View {
    let message: String
    let type: AlertType
    
    enum AlertType {
        case info
        case warning
        case danger
        
        var backgroundColor: Color {
            switch self {
            case .info: return Color.aegisInfoLight
            case .warning: return Color.aegisWarningLight
            case .danger: return Color.aegisDangerLight
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .info: return Color.aegisInfo
            case .warning: return Color.aegisWarning
            case .danger: return Color.aegisDanger
            }
        }
        
        var icon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .danger: return "xmark.circle.fill"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: AegisSpacing.sm) {
            Image(systemName: type.icon)
                .font(.system(size: 14, weight: .semibold))
            
            Text(message)
                .font(.system(size: 13, design: .default))
                .lineLimit(3)
            
            Spacer()
        }
        .foregroundColor(type.foregroundColor)
        .padding(AegisSpacing.md)
        .background(type.backgroundColor)
        .cornerRadius(AegisBorderRadius.small)
        .accessibility(label: Text("Alert"))
        .accessibility(value: Text(message))
    }
}

// MARK: - Preview Helper

#if DEBUG
struct ComponentsPreview: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: AegisSpacing.lg) {
                SeverityBadge(severity: .high)
                SeverityBadge(severity: .medium)
                SeverityBadge(severity: .low)
                PrimaryButton(title: "Scan") {}
                SecondaryButton(title: "Settings") {}
                StatusCard(title: "Threats Found", value: "3", icon: "exclamationmark.circle")
            }
            .padding(AegisSpacing.md)
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
            
            VStack(spacing: AegisSpacing.lg) {
                SeverityBadge(severity: .high)
                SeverityBadge(severity: .medium)
                SeverityBadge(severity: .low)
                PrimaryButton(title: "Scan") {}
                SecondaryButton(title: "Settings") {}
                StatusCard(title: "Threats Found", value: "3", icon: "exclamationmark.circle")
            }
            .padding(AegisSpacing.md)
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
#endif
