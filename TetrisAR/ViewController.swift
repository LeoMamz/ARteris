//
//  ViewController.swift
//  ARTetris
//
//  Created by 229Studio on 6/17/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Foundation

class ViewController: UIViewController, ARSCNViewDelegate {
    var model: Int = 1

    @IBOutlet var sceneView: ARSCNView!
	var tetris: TetrisEngine?
    var timer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set the view's delegate
		sceneView.delegate = self
		
		// Create a new scene
		sceneView.scene = SCNScene()
		// Use default lighting
		sceneView.autoenablesDefaultLighting = true
		
		addGestures()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if (self.tetris?.gameOverFlag == 1){
                self.returnToRankingname()
            }
            
        }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Run the view's session
		sceneView.session.run(getSessionConfiguration())
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		// Pause the view's session
		sceneView.session.pause()
	}
	
    private func getSessionConfiguration() -> ARConfiguration {
        if ARWorldTrackingConfiguration.isSupported {
			// Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
			configuration.planeDetection = .horizontal
			return configuration;
		} else {
			// Slightly less immersive AR experience due to lower end processor
            return AROrientationTrackingConfiguration()
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		// We need async execution to get anchor node's position relative to the root
		DispatchQueue.main.async {
			if let planeAnchor = anchor as? ARPlaneAnchor {
				// For a first detected plane
				if (self.tetris == nil) {
					// get center of the plane
					let x = planeAnchor.center.x + node.position.x
					let y = planeAnchor.center.y + node.position.y
					let z = planeAnchor.center.z + node.position.z
					// initialize Tetris with a well placed on this plane
                    var speed: double_t = 1.5
                    var config: TetrisConfig = TetrisConfig.standard3
                    switch(self.model){
                    case 1:
                        config = TetrisConfig.standard3
                        speed = 1.5
                    case 2:
                        config = TetrisConfig.standard2
                        speed = 1.0
                    case 3:
                        config = TetrisConfig.standard1
                        speed = 0.5
                    default:
                        config = TetrisConfig.standard3
                    }
					//let config = TetrisConfig.standard
					let well = TetrisWell(config)
					let scene = TetrisScene(config, self.sceneView.scene, x, y, z)
					self.tetris = TetrisEngine(config, well, scene, speed)
				}
			}
		}
	}
	
	private func addGestures() {
		let swiftDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
		swiftDown.direction = .down
		self.view.addGestureRecognizer(swiftDown)
		
		let swiftUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
		swiftUp.direction = .up
		self.view.addGestureRecognizer(swiftUp)
        
        let swiftleft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swiftUp.direction = .left
        self.view.addGestureRecognizer(swiftleft)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		self.view.addGestureRecognizer(tap)
	}
    
    func returnToModelChoose() {
        //let vc = GameSetViewController()
        //self.present(vc, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "GameSetViewController") as? GameSetViewController else {  return }
        self.present(secondVC, animated: true, completion: nil)
    }
    func returnToBegin() {
        //let vc = GameSetViewController()
        //self.present(vc, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "BeginViewController") as? BeginViewController else {  return }
        self.present(secondVC, animated: true, completion: nil)
    }
    func returnToRankingname() {
        //let vc = GameSetViewController()
        //self.present(vc, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "RankingNameViewController") as? RankingNameViewController else {  return }
        secondVC.score = self.tetris?.scores ?? 0
        self.present(secondVC, animated: true, completion: nil)
    }
    
	@objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
		if (sender.direction == .down) {
			// drop down tetromino on swipe down
			tetris?.drop()
		}
//        else if(sender.direction == .left){
//            // rotate tetromino on swipe up
//            returnToModelChoose()
//        }
        else{
            // rotate tetromino on swipe up if(sender.direction == .up)
            tetris?.rotate()
        }
	}
	
	@objc private func handleTap(sender: UITapGestureRecognizer) {
		let location = sender.location(in: self.view)
		let x = location.x / self.view.bounds.size.width
        let y = location.y / self.view.bounds.size.height
		if (x < 0.5 && y > 0.2) {
			// move tetromino left on tap first 50% of the screen
			tetris?.left()
		} else if(x >= 0.5 && y > 0.2) {
			// move tetromino right on tap second 50% of the screen
			tetris?.right()
        }else if(y <= 0.2){
            returnToModelChoose()
        }
	}
	
}
