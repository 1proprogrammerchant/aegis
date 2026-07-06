import SwiftUI

/// Aegis design system colors following the design tokens
struct AegisColors {
    // MARK: - Light Theme Colors
    
    static let lightPrimary = Color(red: 0.039, green: 0.518, blue: 1.0)
    static let lightPrimaryVariant = Color(red: 0.0, green: 0.318, blue: 0.835)
    static let lightBackground = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let lightSurface = Color(red: 0.949, green: 0.949, blue: 0.969)
    static let lightSurfaceVariant = Color(red: 0.898, green: 0.898, blue: 0.918)
    static let lightText = Color(red: 0.110, green: 0.110, blue: 0.120)
    static let lightTextSecondary = Color(red: 0.557, green: 0.557, blue: 0.576)
    static let lightTextTertiary = Color(red: 0.780, green: 0.780, blue: 0.800)
    static let lightBorder = Color(red: 0.898, green: 0.898, blue: 0.918)
    static let lightDanger = Color(red: 1.0, green: 0.235, blue: 0.188)
    static let lightDangerLight = Color(red: 1.0, green: 0.898, blue: 0.882)
    static let lightSuccess = Color(red: 0.204, green: 0.784, blue: 0.349)
    static let lightSuccessLight = Color(red: 0.882, green: 0.961, blue: 0.882)
    static let lightWarning = Color(red: 1.0, green: 0.596, blue: 0.0)
    static let lightWarningLight = Color(red: 1.0, green: 0.953, blue: 0.878)
    
    // MARK: - Dark Theme Colors
    
    static let darkPrimary = Color(red: 0.039, green: 0.518, blue: 1.0)
    static let darkPrimaryVariant = Color(red: 0.329, green: 0.702, blue: 1.0)
    static let darkBackground = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let darkSurface = Color(red: 0.110, green: 0.110, blue: 0.120)
    static let darkSurfaceVariant = Color(red: 0.173, green: 0.173, blue: 0.180)
    static let darkText = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let darkTextSecondary = Color(red: 0.557, green: 0.557, blue: 0.576)
    static let darkTextTertiary = Color(red: 0.263, green: 0.263, blue: 0.267)
    static let darkBorder = Color(red: 0.227, green: 0.227, blue: 0.235)
    static let darkDanger = Color(red: 1.0, green: 0.271, blue: 0.227)
    static let darkDangerLight = Color(red: 0.173, green: 0.067, blue: 0.082)
    static let darkSuccess = Color(red: 0.188, green: 0.690, blue: 0.753)
    static let darkSuccessLight = Color(red: 0.051, green: 0.180, blue: 0.180)
    static let darkWarning = Color(red: 1.0, green: 0.596, blue: 0.0)
    static let darkWarningLight = Color(red: 0.169, green: 0.133, blue: 0.0)
}

// MARK: - Adaptive Color Extension

extension Color {
    /// Primary action color
    static let aegisPrimary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkPrimary : AegisColors.lightPrimary
    })
    
    /// Primary action color variant (for pressed state)
    static let aegisPrimaryVariant = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkPrimaryVariant : AegisColors.lightPrimaryVariant
    })
    
    /// Background color
    static let aegisBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkBackground : AegisColors.lightBackground
    })
    
    /// Surface color (cards, sheets)
    static let aegisSurface = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkSurface : AegisColors.lightSurface
    })
    
    /// Secondary surface color
    static let aegisSurfaceVariant = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkSurfaceVariant : AegisColors.lightSurfaceVariant
    })
    
    /// Primary text color
    static let aegisText = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkText : AegisColors.lightText
    })
    
    /// Secondary text color
    static let aegisTextSecondary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkTextSecondary : AegisColors.lightTextSecondary
    })
    
    /// Tertiary text color
    static let aegisTextTertiary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkTextTertiary : AegisColors.lightTextTertiary
    })
    
    /// Border color
    static let aegisBorder = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkBorder : AegisColors.lightBorder
    })
    
    /// Danger/high severity color
    static let aegisDanger = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkDanger : AegisColors.lightDanger
    })
    
    /// Danger/high severity light background
    static let aegisDangerLight = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkDangerLight : AegisColors.lightDangerLight
    })
    
    /// Success/low severity color
    static let aegisSuccess = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkSuccess : AegisColors.lightSuccess
    })
    
    /// Success/low severity light background
    static let aegisSuccessLight = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkSuccessLight : AegisColors.lightSuccessLight
    })
    
    /// Warning/medium severity color
    static let aegisWarning = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkWarning : AegisColors.lightWarning
    })
    
    /// Info color
    static let aegisInfo = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? AegisColors.darkPrimary : AegisColors.lightPrimary
    })
    
    /// Info light background
    static let aegisInfoLight = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark ? Color(red: 0.0, green: 0.118, blue: 0.235) : Color(red: 0.878, green: 0.941, blue: 1.0)
    })

// MARK: - Spacing and Layout Constants

struct AegisSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

struct AegisBorderRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let full: CGFloat = 24
}
