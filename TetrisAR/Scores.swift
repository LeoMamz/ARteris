//
//  Scores.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/16.
//  Copyright © 2019 Exyte. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Scores: NSObject, NSCoding{
    var score: Int = 0
    var name: String = "匿名玩家"
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("scores")
    
    //MARK: Types
    struct PropertyKey {
        static let score = "score"
        static let name = "name"
    }
    
    //MARK: Initialization
    init?(score: Int, name: String) {
        // The rating must be between 0 and 5 inclusively
        guard (score >= 0) else {
            return nil
        }
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.score = score
        self.name = name
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(score, forKey: PropertyKey.score)
        aCoder.encode(name, forKey: PropertyKey.name)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        
        // Must call designated initializer.
        self.init(score: score, name: name)
    }
    
}
