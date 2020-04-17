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

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

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
    var oLabirinto: criaçãoDoLabirinto!
    var tempoDeEspera: TimeInterval = 0
    var currentlyOb = false
    var obWarningNode: SCNNode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self
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
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}

extension float4x4 {
    var translation:  SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
