//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 20/4/22.
//

import Foundation
import SceneKit

extension ARViewController {
    func loadScene() -> SCNScene {
        let scene = SCNScene()
        let scnView = SCNView()

        scnView.scene = scene

        scnView.allowsCameraControl = true

        scnView.showsStatistics = false

        scnView.backgroundColor = UIColor.clear

        let flagNode = SCNNode()

        let flagPoleRadius = 0.004
        let flagPoleHeight = 0.25
        let flagWidth = 0.06
        let flagHeight = 0.04
        
        let flagPole = SCNCylinder(radius: flagPoleRadius, height: flagPoleHeight)
        flagPole.firstMaterial?.diffuse.contents = UIColor.label
        let flagPoleNode = SCNNode(geometry: flagPole)

        let flagGeometry = SCNBox(width: flagWidth, height: flagHeight, length: 0.001, chamferRadius: 0)

        flagGeometry.firstMaterial?.diffuse.contents = flagImage

        let flagViewNode = SCNNode(geometry: flagGeometry)
        flagViewNode.position = .init(flagWidth / 2 + flagPoleRadius, flagPoleHeight / 2 - flagHeight / 2, 0)

        flagNode.addChildNode(flagPoleNode)
        flagNode.addChildNode(flagViewNode)

        scene.rootNode.addChildNode(flagNode)

        return scene
    }
}
