//
//  BombTurret.swift

import SpriteKit

    class BombTower: SKSpriteNode {
      
      static let bombName = "bomb tower"
      
      var closestZombie: SKSpriteNode!
      
      func updateClosestZombie() {
        let gameScene = (self.scene! as! GameScene)
        let zombieArray = gameScene.zombieArray
          
          var prevDistance:CGFloat = 1000000
          var closestZombie = zombieArray[0]
          
          for zombie in zombieArray {
            
            let distance = hypot(zombie.position.x - self.position.x, zombie.position.y - self.position.y)
            if distance < prevDistance {
              prevDistance = distance
              closestZombie = zombie
            }
          }
        self.closestZombie = closestZombie
      }

      func turnTowardsClosestZombie() {
        let angle = atan2(closestZombie.position.x - self.position.x , closestZombie.position.y - self.position.y)
        let actionTurn = SKAction.rotate(toAngle: -(angle - CGFloat(Double.pi/2)), duration: 0.2)
        self.run(actionTurn)
      }
      
      private func makeTurretBullet() -> SKSpriteNode {
        let turretBullet = SKSpriteNode(imageNamed: "Level 1 Turret Bullet")
        turretBullet.position = self.position
        turretBullet.zPosition = 20
        turretBullet.size = CGSize(width: 20, height: 20)
        //turretBullet.setScale (frame.size.height / 5000)
        
        turretBullet.physicsBody = SKPhysicsBody(circleOfRadius: max(turretBullet.size.width / 2, turretBullet.size.height / 2))
        turretBullet.physicsBody?.affectedByGravity = false
        //    turretBullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet //new contact
        //    turretBullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        //    turretBullet.physicsBody!.contactTestBitMask = PhysicsCategories.Zombie
        
        return turretBullet
      }
      
      private func fire(turretBullet: SKSpriteNode) {
        var dx = CGFloat(closestZombie.position.x - self.position.x)
        var dy = CGFloat(closestZombie.position.y - self.position.y)
        let magnitude = sqrt(dx * dx + dy * dy)
        dx /= magnitude
        dy /= magnitude
        
        let vector = CGVector(dx: 4.0 * dx, dy: 4.0 * dy)
        
        turretBullet.physicsBody?.applyImpulse(vector)
      }
      
      func addBulletThenShootAtClosestZOmbie() {
        let bullet = makeTurretBullet()
        scene!.addChild(bullet)
        fire(turretBullet: bullet)
      }
    }


