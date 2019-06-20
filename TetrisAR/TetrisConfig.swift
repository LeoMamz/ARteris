//
//  TetrisConfig.swift
//  ARTetris
//
//  Created by 229Studio on 6/17/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

/** Tetris configuration: width and height of the well */
struct TetrisConfig {
	static let standard: TetrisConfig = TetrisConfig(width: 10, height: 15)
	static let standard1: TetrisConfig = TetrisConfig(width: 8, height: 10)
    static let standard2: TetrisConfig = TetrisConfig(width: 10, height: 15)
    static let standard3: TetrisConfig = TetrisConfig(width: 15, height: 20)
	
	let width: Int
	let height: Int
	
}

