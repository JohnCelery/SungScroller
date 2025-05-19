# Sung Scroller 🏃‍♂️⚖️

**Sung Scroller** is a light-hearted SpriteKit side-scroller starring **Sung**, a quick-witted South-Korean attorney racing through city streets.  Leap over judges’ gavels, stomp pesky tenants, and survive the legal gauntlet for as long as you can.

---

## Gameplay

| Control (iPad)        | Effect                         |
|-----------------------|--------------------------------|
| **Tap** upper half, **↑** or **Space** | Jump (Mario-style arc) |
| **← / →** (hardware keyboard) | Run left / right          |
| **Stomp Tenant**      | “EVICTED!” — tenant drops away |
| **Stomp Judge**       | “OVERRULED!” — judge exits      |
| **Side Collision**    | “OTSC GRANTED” — Game Over      |

Buildings and houses scroll by for depth, while judges and tenants spawn randomly as enemies.

---

## Technical Highlights

* **SwiftUI + SpriteKit** hybrid  
* Modular codebase with four key files  
  * `GameConfig.swift` – all tweakable constants  
  * `Sprites.swift` – sprite-factory that auto-loads PNGs or SF Symbols  
  * `GameScene.swift` – physics, input handling, enemy logic  
  * `ContentView.swift` – SwiftUI wrapper embedding the scene  
* Runs entirely inside **Swift Playgrounds on iPad**—no Mac required  
* Drop custom PNGs named `sung`, `judge`, `tenant`, `house`, `building` into *Assets.xcassets* to skin the game without code changes.

---

## Roadmap

* Power-ups (speed boost, double-jump)  
* Score HUD and high-score storage  
* Parallax sky & ambient sound  
* Level editor for custom obstacle patterns

Enjoy running the legal gauntlet with Sung!