import Foundation
import SwiftUI

/// Severity level for a threat or finding
enum Severity: String, Codable, Hashable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return Color.aegisSuccess
        case .medium: return Color.aegisWarning
        case .high: return Color.aegisDanger
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .low: return Color.aegisSuccessLight
        case .medium: return Color.aegisWarningLight
        case .high: return Color.aegisDangerLight
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
