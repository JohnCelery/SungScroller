import UIKit

/// All tweakable numbers, colors, and timings live here.
enum GameConfig {
    /// Horizontal running speed for Sung. Tuned for a Mario-like feel.
    static let runSpeed: CGFloat      = 250

    /// Upward impulse applied when jumping.
    /// Higher value gives a more "Mario" style arc.
    static let jumpImpulse            = CGVector(dx: 0, dy: 480)
    /// Distance from the screen edge before the camera begins scrolling.
    static let cameraEdge: CGFloat    = 140

    static let enemySpawnGap: CGFloat = 500        // Distance between enemy spawns
    static let envSpawnGap: CGFloat   = 300        // Distance between background buildings

    static let tenantPatrolRange: CGFloat = 80     // How far tenants pace
    static let gavelUpTime: TimeInterval   = 1.0   // Time gavel stays raised
    static let gavelDownTime: TimeInterval = 2.0   // Time between raises

    static let skyColor               = UIColor.cyan.withAlphaComponent(0.15)
}
