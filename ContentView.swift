import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: SKScene {
        let s = GameScene(size: CGSize(width: 400, height: 600))
        s.scaleMode = .resizeFill
        return s
    }
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

struct ContentView: View {
    var body: some View { GameView() }
}