//
//  SceneView.swift
//
//  Created by Jia Chen Yee on 19/4/22.
//

import Foundation
import SceneKit
import SwiftUI

struct SceneView: UIViewRepresentable {
    
    var flagImage: UIImage
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        
        // create and add lights to the scene
        let lightNode0 = SCNNode()
        lightNode0.light = SCNLight()
        lightNode0.light!.type = .ambient
        lightNode0.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode0)
        
        let lightNode1 = SCNNode()
        lightNode1.light = SCNLight()
        lightNode1.light!.type = .omni
        lightNode1.position = SCNVector3(5, -10, 0)
        scene.rootNode.addChildNode(lightNode1)
        
        let scnView = SCNView()
        
        scnView.scene = scene
        
        scnView.allowsCameraControl = true
        
        scnView.showsStatistics = false
        
        scnView.backgroundColor = UIColor.clear
        
        let flagNode = SCNNode()
        
        let flagPole = SCNCylinder(radius: 1, height: 50)
        flagPole.firstMaterial?.diffuse.contents = UIColor.label
        let flagPoleNode = SCNNode(geometry: flagPole)
        
        let flagGeometry = SCNBox(width: 15, height: 10, length: 0.01, chamferRadius: 0)
        
        
        flagGeometry.firstMaterial?.diffuse.contents = flagImage
        
        let flagViewNode = SCNNode(geometry: flagGeometry)
        flagViewNode.position = .init(15 / 2 + 1.1, 25 - 5, 0)
        
        flagNode.addChildNode(flagPoleNode)
        flagNode.addChildNode(flagViewNode)
        
        scnView.scene?.rootNode.addChildNode(flagNode)
        
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: -.pi, z: 0, duration: 5))
        flagNode.runAction(rotateAction)
        let actions = SCNAction.group([
            SCNAction.rotateBy(x: -.pi / 5, y: 0, z: 0, duration: 4),
            SCNAction.moveBy(x: 0, y: 40, z: -10, duration: 4)
        ])
        
        actions.timingMode = .easeInEaseOut
        cameraNode.runAction(actions)
        
        let colorView = UIView()
        
        colorView.backgroundColor = .systemBackground
        
        let animationDuration = 10.0
        
        UIView.animate(withDuration: animationDuration) {
            colorView.backgroundColor = .systemRed.withAlphaComponent(0.25)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            UIView.animate(withDuration: animationDuration) {
                colorView.backgroundColor = [UIColor.systemOrange, .systemYellow, .systemGreen, .systemMint, .systemTeal, .systemCyan, .systemBlue, .systemIndigo, .systemPurple, .systemPink, .systemBrown].randomElement()!.withAlphaComponent(0.25)
            }
        }
        colorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorView)
        view.addConstraints([NSLayoutConstraint(item: colorView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: colorView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: colorView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: colorView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)])
        
        scnView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scnView)
        
        view.addConstraints([NSLayoutConstraint(item: scnView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: scnView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: scnView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
                             NSLayoutConstraint(item: scnView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
