import Foundation
import SwiftUI

/// Severity level for a threat or finding
enum Severity: String, Codable, Hashable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? Color(red: 0.188, green: 0.690, blue: 0.753) : Color(red: 0.204, green: 0.784, blue: 0.349)
        })
        case .medium: return Color(red: 1.0, green: 0.596, blue: 0.0)
        case .high: return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? Color(red: 1.0, green: 0.271, blue: 0.227) : Color(red: 1.0, green: 0.235, blue: 0.188)
        })
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .low: return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? Color(red: 0.051, green: 0.180, blue: 0.180) : Color(red: 0.882, green: 0.961, blue: 0.882)
        })
        case .medium: return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? Color(red: 0.169, green: 0.133, blue: 0.0) : Color(red: 1.0, green: 0.953, blue: 0.878)
        })
        case .high: return Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? Color(red: 0.173, green: 0.067, blue: 0.082) : Color(red: 1.0, green: 0.902, blue: 0.882)
        })
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "info.circle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .high: return "xmark.circle.fill"
        }
    }
}

/// A single scan result item
struct ScanResult: Identifiable, Codable, Hashable {
    let id: UUID
    let filename: String
    let filepath: String
    let detail: String
    let severity: Severity
    let ruleMatched: String
    let evidence: String
    let recommendation: String
    let timestamp: Date
    
    var isQuarantined: Bool = false
}

/// Status of a scan operation
enum ScanStatus: String, Codable {
    case idle = "Idle"
    case scanning = "Scanning"
    case completed = "Completed"
    case failed = "Failed"
}

/// A scan session with multiple results
struct ScanSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    let endTime: Date?
    let status: ScanStatus
    let totalItemsScanned: Int
    let results: [ScanResult]
    let scanType: ScanType
    
    enum ScanType: String, Codable {
        case quick = "Quick"
        case full = "Full"
        case scheduled = "Scheduled"
        case custom = "Custom"
    }
    
    var highSeverityCount: Int {
        results.filter { $0.severity == .high }.count
    }
    
    var mediumSeverityCount: Int {
        results.filter { $0.severity == .medium }.count
    }
    
    var lowSeverityCount: Int {
        results.filter { $0.severity == .low }.count
    }
    
    var durationSeconds: TimeInterval? {
        guard let endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
}

/// A quarantined item
struct QuarantineItem: Identifiable, Codable, Hashable {
    let id: UUID
    let filename: String
    let filepath: String
    let severity: Severity
    let ruleMatched: String
    let quarantineDate: Date
    let originalScanResult: ScanResult
    
    var daysQuarantined: Int {
        Calendar.current.dateComponents([.day], from: quarantineDate, to: Date()).day ?? 0
    }
}

/// Scheduled scan configuration
struct ScheduledScan: Identifiable, Codable {
    let id: UUID
    var isEnabled: Bool
    var frequency: Frequency
    var time: Date
    var scanType: ScanSession.ScanType
    
    enum Frequency: String, Codable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
}

/// Rulepack information
struct Rulepack: Identifiable, Codable {
    let id: UUID
    let version: String
    let releaseDate: Date
    let ruleCount: Int
    let engineVersion: String
    let notes: String?
    
    var isUpdateAvailable: Bool = false
    var nextRulepackVersion: String?
}

/// App status and health information
struct AppStatus: Codable {
    var lastScanDate: Date?
    var lastScanResults: ScanSession?
    var rulepackVersion: String
    var engineVersion: String
    var quarantineItemCount: Int
    var threatsDetected: Int
    var isScanInProgress: Bool
    var scheduledScansEnabled: Bool
    var backgroundScanEnabled: Bool
}
