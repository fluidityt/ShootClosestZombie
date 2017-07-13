    //
    //  GameScene.swift
    
    import SpriteKit
    
    // TODO: delete bullets, hit detection, and add SKConstraint for tracking instead of update.
    // Also, I think that we are iterating too much looking for nodes. Should be able to reduce that.
    // Also also, there are sure to be bugs if zombieArray is empty.
    class GameScene: SKScene {
      
      var zombieArray: [SKSpriteNode] = []
      
      private func makeBombArray() -> [BombTower]? {
        guard self.zombieArray.count > 0 else { return nil }
        
        var towerArray: [BombTower] = []
        self.enumerateChildNodes(withName: BombTower.bombName) { node, _ in towerArray.append(node as! BombTower) }
        guard towerArray.count > 0 else { return nil }
        
        return towerArray
      }
      
      // Makes all the towers find closest zombie, turn,
      private func towersShootEverySecond(towerArray: [BombTower]) {
        
        let action = SKAction.run {
          for bombTower in towerArray {
            guard bombTower.closestZombie != nil else { continue } // I haven't tested this guard statement yet.
            bombTower.addBulletThenShootAtClosestZOmbie()
          }
        }
        self.run(.repeatForever(.sequence([.wait(forDuration: 1), action])))
      }
      
      override func didMove(to view: SKView) {
        // Demo setup:
        removeAllChildren()
        
        makeTestZombie: do {
          spawnZombie(at: CGPoint.zero)
        }
        makeTower1: do {
          let tower = BombTower(color: .yellow, size: CGSize(width: 55, height: 55))
          let turretGun = SKSpriteNode(color: .gray, size: CGSize(width: 25, height: 15))
          turretGun.position.x = tower.frame.maxX + turretGun.size.height/2
          tower.name = BombTower.bombName
          tower.addChild(turretGun)
          addChild(tower)
        }
        makeTower2: do {
          let tower = BombTower(color: .yellow, size: CGSize(width: 55, height: 55))
          let turretGun = SKSpriteNode(color: .gray, size: CGSize(width: 25, height: 15))
          turretGun.position.x = tower.frame.maxX + turretGun.size.height/2
          tower.addChild(turretGun)
          tower.position.x += 200
          tower.name = BombTower.bombName
          addChild(tower)
        }
        
        guard let towerArray = makeBombArray() else { fatalError("couldn't make array!") }
        
        towersShootEverySecond(towerArray: towerArray)
      }
      
      private func spawnZombie(at location: CGPoint) {
        let zombie = SKSpriteNode(color: .blue, size: CGSize(width: 35, height: 50))
        zombieArray.append(zombie)
        zombie.position = location
        zombie.run(.move(by: CGVector(dx: 3000, dy: -3000), duration: 50))
        addChild(zombie)
      }
      
      // Just change this to touchesBegan for it to work on iOS:
      override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        spawnZombie(at: location)
      }
      
      // I think this could be a constrain or action, but I couldn't get either to work right now.
      private func keepTowersTrackingNearestZombie() {
        guard let towerArray = makeBombArray() else { return }
        for tower in towerArray {
          tower.updateClosestZombie()
          tower.turnTowardsClosestZombie()
        }
      }
      
      override func update(_ currentTime: TimeInterval) {
        keepTowersTrackingNearestZombie()
      }
    }
