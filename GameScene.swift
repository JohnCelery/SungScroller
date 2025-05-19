import SpriteKit

// MARK: - Collision bit-masks
struct PhysicsCategory {
    static let none:   UInt32 = 0
    static let sung:   UInt32 = 1 << 0
    static let ground: UInt32 = 1 << 1
    static let judge:  UInt32 = 1 << 2
    static let tenant: UInt32 = 1 << 3
}

// MARK: - Main Scene
class GameScene: SKScene, SKPhysicsContactDelegate {

    // Player sprite
    private let sung = Sprites.make(.sung, size: CGSize(width: 50, height: 50))
    private var moveDir = 0   // –1 left, 0 idle, 1 right
    private var gameOver = false

    /// Update the horizontal movement direction from touch controls.
    func setMoveDir(_ dir: Int) {
        moveDir = dir
    }

    // Spawn distance tracking
    private var lastEnemyX: CGFloat = 0
    private var lastEnvX:   CGFloat = 0

    // ───────────────────────── Scene setup
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        backgroundColor = GameConfig.skyColor

        createGround()
        createSung()
        setupCamera()
    }

    private func createGround() {
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 40)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100_000, height: 20))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)
    }

    private func createSung() {
        sung.position = CGPoint(x: 100, y: 120)
        sung.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        sung.physicsBody?.allowsRotation = false
        sung.physicsBody?.categoryBitMask = PhysicsCategory.sung
        sung.physicsBody?.contactTestBitMask = PhysicsCategory.judge | PhysicsCategory.tenant
        sung.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.judge | PhysicsCategory.tenant
        addChild(sung)
    }

    private func setupCamera() {
        let cam = SKCameraNode()
        camera = cam
        addChild(cam)
    }

    // ───────────────────────── Input
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first.map({ $0.location(in: self).y > frame.midY }) == true { jump() }
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for p in presses {
            guard let key = p.key else { continue }
            switch key.keyCode {
            case .keyboardUpArrow, .keyboardSpacebar: jump()
            case .keyboardLeftArrow:  moveDir = -1
            case .keyboardRightArrow: moveDir =  1
            default: break
            }
        }
    }
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for p in presses {
            guard let key = p.key else { continue }
            if key.keyCode == .keyboardLeftArrow  && moveDir == -1 { moveDir = 0 }
            if key.keyCode == .keyboardRightArrow && moveDir ==  1 { moveDir = 0 }
        }
    }

    func jump() {
        guard !gameOver,
              let body = sung.physicsBody,
              abs(body.velocity.dy) < 1 else { return }
        // Limit jumping so Sung only reaches roughly mid-screen height
        let maxY = frame.midY
        let dy = maxY - sung.position.y
        guard dy > 0 else { return }

        let gravity = abs(physicsWorld.gravity.dy)
        let targetVel = sqrt(2 * gravity * dy)
        body.velocity = CGVector(dx: body.velocity.dx, dy: 0)
        body.applyImpulse(CGVector(dx: 0, dy: targetVel * body.mass))
    }

    // ───────────────────────── Game loop
    override func update(_ currentTime: TimeInterval) {
        guard !gameOver else { return }

        // Move left/right
        sung.physicsBody?.velocity.dx = CGFloat(moveDir) * GameConfig.runSpeed

        // Camera follow
        camera?.position = CGPoint(x: sung.position.x + GameConfig.cameraLead,
                                   y: frame.midY)

        // Spawn scenery & enemies
        spawnEnemiesIfNeeded()
        spawnEnvironmentIfNeeded()
    }

    // ───────────────────────── Spawning
    private func spawnEnemiesIfNeeded() {
        if sung.position.x + GameConfig.enemySpawnGap > lastEnemyX {
            lastEnemyX += GameConfig.enemySpawnGap

            let isJudge = Bool.random()
            let kind: Sprites.Kind = isJudge ? .judge : .tenant
            let enemy = Sprites.make(kind, size: CGSize(width: 46, height: 46))
            enemy.position = CGPoint(x: lastEnemyX + 300, y: 60)
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: 23)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = isJudge ? PhysicsCategory.judge : PhysicsCategory.tenant
            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.sung
            enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
            addChild(enemy)

            let speed: CGFloat = 100
            let distance       = enemy.position.x + 1000
            enemy.run(.sequence([.moveBy(x: -distance, y: 0,
                                         duration: TimeInterval(distance / speed)),
                                 .removeFromParent()]))
        }
    }

    private func spawnEnvironmentIfNeeded() {
        if sung.position.x + GameConfig.envSpawnGap > lastEnvX {
            lastEnvX += GameConfig.envSpawnGap
            let kind: Sprites.Kind = Bool.random() ? .house : .building
            let env = Sprites.make(kind, size: CGSize(width: 80, height: 80))
            env.position = CGPoint(x: lastEnvX + 300, y: 100)
            env.zPosition = -1
            addChild(env)

            let dist: CGFloat = env.position.x + 1000
            env.run(.sequence([.moveBy(x: -dist, y: 0, duration: 60),
                               .removeFromParent()]))
        }
    }

    // ───────────────────────── Collisions
    func didBegin(_ contact: SKPhysicsContact) {
        guard !gameOver else { return }

        let other = contact.bodyA.categoryBitMask == PhysicsCategory.sung
                    ? contact.bodyB : contact.bodyA
        guard let node = other.node else { return }

        let stomp = sung.position.y > node.position.y + 20 &&
                   (sung.physicsBody?.velocity.dy ?? 0) < 0

        if stomp {
            let text = other.categoryBitMask == PhysicsCategory.tenant
                     ? "EVICTED!" : "OVERRULED!"
            showMessage(text)
            node.physicsBody = nil
            node.run(.sequence([.moveBy(x: 0, y: -600, duration: 1),
                                .removeFromParent()]))
            sung.physicsBody?.velocity.dy = 0
            sung.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 220))
        } else {
            showMessage("OTSC GRANTED")
            endGame()
        }
    }

    // ───────────────────────── HUD
    private func showMessage(_ text: String) {
        let label = SKLabelNode(text: text)
        label.fontName = "Avenir-Heavy"
        label.fontSize = 36
        label.fontColor = .black
        label.position = CGPoint(x: sung.position.x,
                                 y: frame.midY + 120)
        label.zPosition = 200
        addChild(label)
        label.run(.sequence([.wait(forDuration: 2),
                             .fadeOut(withDuration: 0.5),
                             .removeFromParent()]))
    }

    private func endGame() {
        gameOver = true
        physicsWorld.speed = 0
    }
}