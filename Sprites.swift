import SpriteKit
import UIKit

/// Factory for game sprites.  Looks for a PNG in Assets.xcassets;
/// if none, falls back to an SF-Symbol icon; if that fails, a solid color box.
enum Sprites {

    enum Kind { case sung, judge, tenant, gavel, house, building }

    static func make(_ kind: Kind, size: CGSize) -> SKSpriteNode {
        let (png, symbol, tint): (String, String, UIColor) = {
            switch kind {
            case .sung:      return ("sung",      "person.circle.fill",        .systemBlue)
            case .judge:     return ("judge",     "theatermasks.circle.fill",  .systemPurple)
            case .tenant:    return ("tenant",    "person.circle",             .systemRed)
            case .gavel:     return ("gavel",     "hammer.circle.fill",        .brown)
            case .house:     return ("house",     "house.fill",                .systemGreen)
            case .building:  return ("building",  "building.2.fill",           .systemTeal)
            }
        }()

        // 1️⃣ PNG override
        if let img = UIImage(named: png) {
            return SKSpriteNode(texture: SKTexture(image: img), size: size)
        }

        // 2️⃣ SF Symbol fallback
        let cfg = UIImage.SymbolConfiguration(pointSize: size.height, weight: .regular)
        if let img = UIImage(systemName: symbol, withConfiguration: cfg)?
            .withTintColor(tint, renderingMode: .alwaysOriginal) {
            return SKSpriteNode(texture: SKTexture(image: img))
        }

        // 3️⃣ Colored rectangle fallback
        return SKSpriteNode(color: tint, size: size)
    }
}