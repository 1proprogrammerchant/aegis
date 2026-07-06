import SwiftUI

// NOTE: This prototype has been moved to Views/HomeView.swift
// Please use EnhancedHomeView from that location instead.
// This file is kept for reference only.

struct HomeView_Deprecated: View {
    @State private var scanning = false
    @State private var results: [ScanResult] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Aegis")
                            .font(.largeTitle).bold()
                        Text("Status: Ready")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: startScan) {
                        Text(scanning ? "Scanning…" : "Quick Scan")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()

                List(results) { r in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(r.title).font(.headline)
                            Text(r.detail).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(r.severity.rawValue).foregroundColor(r.severity.color)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }

    func startScan() {
        scanning = true
        // Prototype: simulate results then stop
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.results = [
                ScanResult_Deprecated(id: UUID(), title: "suspicious_file.pdf", detail: "Matched rule 'suspicious_pdf'", severity: .high),
                ScanResult_Deprecated(id: UUID(), title: "advert.png", detail: "Low-risk tracker data", severity: .low)
            ]
            scanning = false
        }
    }
}

struct ScanResult_Deprecated: Identifiable {
    let id: UUID
    let title: String
    let detail: String
    let severity: Severity
}

#if DEBUG
struct HomeView_Deprecated_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_Deprecated()
    }
}
#endif

