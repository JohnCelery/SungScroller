import SwiftUI
import GameController

/// On-screen controls for devices without a hardware keyboard.
struct TouchControls: View {
    let scene: GameScene
    @State private var hasKeyboard = GCKeyboard.coalesced != nil

    var body: some View {
        Group {
            if !hasKeyboard {
                VStack {
                    Spacer()
                    HStack {
                        HoldButton(symbol: "chevron.left.circle.fill") {
                            scene.setMoveDir(-1)
                        } onUp: {
                            scene.setMoveDir(0)
                        }
                        Spacer()
                        VStack(spacing: 20) {
                            HoldButton(symbol: "arrow.up.circle.fill") {
                                scene.jump()
                            }
                            HoldButton(symbol: "chevron.right.circle.fill") {
                                scene.setMoveDir(1)
                            } onUp: {
                                scene.setMoveDir(0)
                            }
                        }
                    }
                    .font(.system(size: 48))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
                .onAppear(perform: setupListeners)
            }
        }
    }

    private func setupListeners() {
        NotificationCenter.default.addObserver(forName: .GCKeyboardDidConnect,
                                               object: nil, queue: .main) { _ in
            hasKeyboard = true
        }
        NotificationCenter.default.addObserver(forName: .GCKeyboardDidDisconnect,
                                               object: nil, queue: .main) { _ in
            hasKeyboard = false
        }
    }
}

/// A button that reports press and release events.
struct HoldButton: View {
    let symbol: String
    var onDown: () -> Void
    var onUp: (() -> Void)? = nil
    @GestureState private var pressed = false

    var body: some View {
        Image(systemName: symbol)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($pressed) { _, state, _ in
                        if !state { onDown() }
                        state = true
                    }
                    .onEnded { _ in
                        onUp?()
                    }
            )
    }
}
