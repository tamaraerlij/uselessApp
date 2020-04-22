//
//  ViewController.swift
//  uselessApp
//
//  Created by Tamara Erlij on 17/04/20.
//  Copyright © 2020 Tamara Erlij. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

//MARK: Integrar o labirinto
class LabirintoViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
      //MARK: Propriedades do labirinto
    //Só será verdadeira quando o usuário tocar na tela
    var labirintoIsSetUp = false
    
    //Distância da esquerda para a direita
    var larguraDoLabirinto: Float = 11.0
    
    //Profundidade
    var comprimentoDoLabirinto: Float = 11.0
    
    //Altura
    var alturaDoLabirinto: Float = 2.0
    
    // Largura de cada parede, tal que tanto a largura e o comprimento do labirinto devem ser proporcionais.
    var comprimentoPorUnidade: Float = 1.0
    
    //Outras variáveis
    var entradaDoLabirinto: SCNVector3! 
    var oLabirinto: CriaçãoDoLabirinto!
    var tempoDeEspera: TimeInterval = 0
    var currentlyOb = false
    var obWarningNode: SCNNode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self
        
        // Alerta em vermelho
         let obWarning = SCNBox(width: 0.1, height: 0.3, length: 0.1, chamferRadius: 0)
         let color = UIColor.red
         obWarning.materials.first?.diffuse.contents = color
         obWarningNode = SCNNode(geometry: obWarning)
         obWarningNode.position = SCNVector3Make(0, 0, -0.1)
         sceneView.pointOfView?.addChildNode(obWarningNode)
         
         addTapGestureToSceneView()
        
         oLabirinto = CriaçãoDoLabirinto(Int(larguraDoLabirinto/comprimentoPorUnidade), Int(comprimentoDoLabirinto/comprimentoPorUnidade))
    }
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LabirintoViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
           let tapLocation = recognizer.location(in: sceneView)
           let hitTestResults = sceneView.hitTest(tapLocation)

               guard let node = hitTestResults.first?.node else {
               if labirintoIsSetUp == false {
                   let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
                   
                if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                       let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                       entradaDoLabirinto = SCNVector3(x: translation.x, y: translation.y, z: translation.z)
                       setUpMaze()
                   }
               }
               return
           }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
           print("contact")
           currentlyOb = true
       }
       
       func setUpMaze() {
           let topLeftPos = SCNVector3(entradaDoLabirinto.x - larguraDoLabirinto/2, entradaDoLabirinto.y, entradaDoLabirinto.z - comprimentoDoLabirinto)
           
           for j in 0..<Int(comprimentoDoLabirinto/comprimentoPorUnidade) {
               for i in 0..<oLabirinto.width {
                   addPillar(xPos: topLeftPos.x + Float(i)*comprimentoPorUnidade, zPos: topLeftPos.z + Float(j)*comprimentoPorUnidade)
                   if (j == 0) {
                       if (i != (Int(larguraDoLabirinto/comprimentoPorUnidade)) / 2) {
                           if (oLabirinto.maze[i][j] & Direction.north.rawValue) == 0 {
                               addWall(width: comprimentoPorUnidade-0.1, length: 0.1, xPos: topLeftPos.x + 0.5*comprimentoPorUnidade + Float(i)*comprimentoPorUnidade, zPos: topLeftPos.z + Float(j)*comprimentoPorUnidade)
                           }
                       }
                   }
                   else {
                       if (oLabirinto.maze[i][j] & Direction.north.rawValue) == 0 {
                           addWall(width: comprimentoPorUnidade-0.1, length: 0.1, xPos: topLeftPos.x + 0.5*comprimentoPorUnidade + Float(i)*comprimentoPorUnidade, zPos: topLeftPos.z + Float(j)*comprimentoPorUnidade)
                       }
                   }
               }
               addPillar(xPos: topLeftPos.x + larguraDoLabirinto, zPos: topLeftPos.z + Float(j)*comprimentoPorUnidade)
        
               for i in 0..<Int(larguraDoLabirinto/comprimentoPorUnidade) {
                   if (oLabirinto.maze[i][j] & Direction.west.rawValue) == 0 {
                       addWall(width: 0.1, length: comprimentoPorUnidade-0.1, xPos: topLeftPos.x + Float(i)*comprimentoPorUnidade, zPos: topLeftPos.z + 0.5*comprimentoPorUnidade + Float(j)*comprimentoPorUnidade)
                   }
               }
               addWall(width: 0.1, length: comprimentoPorUnidade-0.1, xPos: topLeftPos.x + larguraDoLabirinto, zPos: topLeftPos.z + 0.5*comprimentoPorUnidade + Float(j)*comprimentoPorUnidade)
           }
           
           // manually builds last row of walls since the row isn't auto-generated
           for i in 0..<Int(larguraDoLabirinto/comprimentoPorUnidade) {
               addPillar(xPos: topLeftPos.x + Float(i)*comprimentoPorUnidade, zPos: entradaDoLabirinto.z)
               if i != (Int(larguraDoLabirinto/comprimentoPorUnidade)) / 2 {
                   addWall(width: comprimentoPorUnidade-0.1, length: 0.1, xPos: topLeftPos.x + 0.5*comprimentoPorUnidade + Float(i)*comprimentoPorUnidade, zPos: entradaDoLabirinto.z)
               }
           }
           addPillar(xPos: topLeftPos.x + larguraDoLabirinto, zPos: entradaDoLabirinto.z)
           
           labirintoIsSetUp = true
       }
       
       func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
           
           if time > tempoDeEspera{
               spawnObCheckNode()
               currentlyOb = false
      //         removeFallenObCheckNodes()
               tempoDeEspera = time + TimeInterval(0.5)
           }
       }
       
       func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
           if currentlyOb == true {
               obWarningNode.opacity = 1
           }
           else {
               obWarningNode.opacity = 0
           }
       }
       
       func spawnObCheckNode() {
           let obCheckSphere = SCNSphere(radius: 0.02)
           let obCheckNode = SCNNode(geometry: obCheckSphere)
           obCheckNode.opacity = 0
           
           obCheckNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
           obCheckNode.physicsBody?.categoryBitMask = CategoriaFísica.Camera
           obCheckNode.physicsBody?.contactTestBitMask = CategoriaFísica.WallOrPillar
           obCheckNode.physicsBody?.collisionBitMask = CategoriaFísica.None
           
           obCheckNode.position = SCNVector3Make(0, 0, 0)
           sceneView.pointOfView?.addChildNode(obCheckNode)
       }
       
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
       func addPillar(xPos: Float, zPos: Float) {
           let pillar = SCNBox(width: 0.1, height: CGFloat(alturaDoLabirinto), length: 0.1, chamferRadius: 0)
           
           // adicionando a textura para cada pilar
           let pillarTexture = UIImage(named: "paredeRosa")
           let pillarMaterial = SCNMaterial()
           pillarMaterial.diffuse.contents = pillarTexture
           pillarMaterial.isDoubleSided = true
           pillar.materials = [pillarMaterial]
           
           let pillarNode = SCNNode()
           pillarNode.geometry = pillar
           pillarNode.position = SCNVector3(xPos, entradaDoLabirinto.y + (alturaDoLabirinto/2), zPos)
           
           sceneView.scene.rootNode.addChildNode(pillarNode)
       }
    
    func addWall(width: Float, length: Float, xPos: Float, zPos: Float) {
        let wall = SCNBox(width: CGFloat(width), height: CGFloat(alturaDoLabirinto), length: CGFloat(length), chamferRadius: 0)
        
        // textura para a parede
        let wallTexture = UIImage(named: "paredeRosa")
        let wallMaterial = SCNMaterial()
        wallMaterial.diffuse.contents = wallTexture
        wallMaterial.isDoubleSided = true
        wall.materials = [wallMaterial]

        let wallNode = SCNNode()
        wallNode.geometry = wall
        
        wallNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        wallNode.physicsBody?.categoryBitMask = CategoriaFísica.WallOrPillar
        wallNode.physicsBody?.contactTestBitMask = CategoriaFísica.Camera
        wallNode.physicsBody?.collisionBitMask = CategoriaFísica.None
        
        wallNode.position = SCNVector3(xPos, entradaDoLabirinto.y + (alturaDoLabirinto/2), zPos)

        sceneView.scene.rootNode.addChildNode(wallNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
}

extension float4x4 {
    var translation:  SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
