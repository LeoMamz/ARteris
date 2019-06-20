//
//  TetrisEngine.swift
//  ARTetris
//
//  Created by 229Studio on 6/17/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import Foundation
import SceneKit

/** Tetris game enigne */
class TetrisEngine {
	
	let config: TetrisConfig
	let well: TetrisWell
	let scene: TetrisScene
    let speed: double_t
	
    var gameOverFlag = 0
	var current: TetrisState
	var timer: Timer?
	var scores = 0
	
    init(_ config: TetrisConfig, _ well: TetrisWell, _ scene: TetrisScene, _ speed: double_t) {
		self.config = config
		self.well = well
		self.scene = scene
		self.current = .random(config)
		self.scene.show(current)
        self.speed = speed
		startTimer()
        self.scene.showScores(self.scores)
	}
	
	func rotate() { setState(current.rotate()) }
	
	func left() { setState(current.left()) }
	
	func right() { setState(current.right()) }
	
	func drop() {
		animate(onComplete: addCurrentTetrominoToWell) {
			let initial = current
			while(!well.hasCollision(current.down())) {
				current = current.down()
			}
			return scene.drop(from: initial, to: current)
		}
	}

	private func setState(_ state: TetrisState) {
        scene.updateScores(scores)
		if (!well.hasCollision(state)) {
			self.current = state
			scene.show(state)
		}
	}
	
	private func addCurrentTetrominoToWell() {
		well.add(current)
		scene.addToWell(current)
		
		let lines = well.clearFilledLines()
		if (lines.isEmpty) {
			nextTetromino()
		} else {
			animate(onComplete: nextTetromino) {
				let scores = getScores(lines.count)
				self.scores += scores
                scene.updateScores(self.scores)
				return scene.removeLines(lines, scores)
			}
		}
	}
	
	private func nextTetromino() {
		current = .random(config)
		if (well.hasCollision(current)) {
			stopTimer()
            self.scene.gameOverFlag = 1
            self.gameOverFlag = 1
            //print("lskdjfklsdjklfjklsdjfklsdgjasdklfjklLKfjdlks fjkl上岛咖啡健康绿色的减肥考虑到实际付款了就是打开立方尽快落实地方快来收到了开发建设卡了")
            //print(self.scene.gameOverFlag)
			scene.showGameOver(scores)
		} else {
			scene.show(current)
		}
	}
	
	private func getScores(_ lineCount: Int) -> Int {
		switch lineCount {
		case 1:
			return 100
		case 2:
			return 300
		case 3:
			return 500
		default:
			return 800
		}
	}
	
	private func animate(onComplete: @escaping () -> Void, block: () -> CFTimeInterval) {
		self.stopTimer()
		Timer.scheduledTimer(withTimeInterval: block(), repeats: false) { _ in
			self.startTimer()
			onComplete()
		}
	}
	
	private func startTimer() {
		self.timer = Timer.scheduledTimer(withTimeInterval: self.speed, repeats: true) { _ in
			let down = self.current.down()
			if (self.well.hasCollision(down)) {
				self.addCurrentTetrominoToWell()
			} else {
				self.current = down
				self.scene.show(self.current)
			}
            if (self.scene.gameOverFlag == 1){
                self.gameOverFlag = 1
            }
            //print("Engine 中的o游戏结束标志：")
            //print(self.gameOverFlag)
		}
	}
	
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
}
