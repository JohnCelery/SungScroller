import SwiftUI
import SpriteKit

struct GameView: View {
    let scene: GameScene = {
        let s = GameScene(size: CGSize(width: 400, height: 600))
        s.scaleMode = .resizeFill
        return s
    }()

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            TouchControls(scene: scene)
        }
    }
}

struct ContentView: View {
    var body: some View { GameView() }
}