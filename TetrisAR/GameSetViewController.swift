//
//  GameSetViewController.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/15.
//  Copyright © 2019 Exyte. All rights reserved.
//

import UIKit
import os.log
import Foundation

class GameSetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "degreeSelect":
            os_log("游戏开始！", log: OSLog.default, type: .debug)
            
        case "easyModel":
            os_log("进入简单模式！", log: OSLog.default, type: .debug)
            guard let ViewController = segue.destination as? ViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            ViewController.model = 1
            
        case "normalModel":
            os_log("进入中等模式！", log: OSLog.default, type: .debug)
            guard let ViewController = segue.destination as? ViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            ViewController.model = 2
            
        case "hardModel":
            os_log("进入困难模式！", log: OSLog.default, type: .debug)
            guard let ViewController = segue.destination as? ViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            ViewController.model = 3
            
        case "back":
            os_log("返回！", log: OSLog.default, type: .debug)
            guard segue.destination is BeginViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        case "rankingList":
            os_log("进入排行榜！", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
 

}
