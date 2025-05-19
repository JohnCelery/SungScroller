import UIKit

/// All tweakable numbers, colors, and timings live here.
enum GameConfig {
    static let runSpeed: CGFloat      = 160        // Horizontal velocity
    static let jumpImpulse            = CGVector(dx: 0, dy: 330)
    static let cameraLead: CGFloat    = 140        // Camera looks ahead of Sung

    static let enemySpawnGap: CGFloat = 500        // Distance between enemy spawns
    static let envSpawnGap: CGFloat   = 300        // Distance between background buildings

    static let skyColor               = UIColor.cyan.withAlphaComponent(0.15)
}