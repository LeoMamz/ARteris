//
//  GIFTest.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/16.
//  Copyright © 2019 Exyte. All rights reserved.
//

import Foundation
import UIKit
//图片处理框架
import ImageIO
import os.log

class GIFTest: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var images: Array<String> = ["begin.gif","1.gif","2.gif","3.gif","4.gif"]
    var scores = [Scores]()
    var scoreFlag = 0
    var nameFlag = 0
    var name = "mamz"
    var scoreForName = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGif(self.images[2])
        //startGif(self.images[0])
        // Handle the text field’s user input through delegate callbacks.
        text.delegate = self
        
        let savedScores = loadScores()
        
        if savedScores?.count ?? 0 > 0 {
            self.scores = savedScores ?? [Scores]()
        }else{
            guard let dataTemp = Scores(score: 100, name: "初始数据") else { return }
            self.scores.append(dataTemp)
        }
        
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        //navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = self.text.text ?? ""
        
        saveButton.isEnabled = !(text.isEmpty)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBAction func button2(_ sender: UIButton) {
        print(scores)
        print("分割线")
        guard let testData = Scores(score: 999, name: "test1") else { return }
        self.scores.append(testData)
        print(scores)
        let nameText = self.text.text ?? "未输入"
        
        guard let dataTemp = Scores(score: 100, name: nameText) else {
            print("请输入text数据")
            return
        }
        print("输入数据成功")
        self.scores.append(dataTemp)
        saveScores()
        
    }
    
    @IBAction func button(_ sender: UIButton) {
        let savedScores = loadScores()
        print(scores)
        if savedScores?.count ?? 0 > 0 {
            self.scores = savedScores ?? [Scores]()
        }
        print("分割线")
        print(scores)
        self.label.text = String(self.scores.count)
        saveScores()
    }
    
    
    func saveScores() {
        let fullPath = getDocumentsDirectory().appendingPathComponent("scores")
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Scores successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save scores...", log: OSLog.default, type: .error)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func loadScores() -> [Scores]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("scores")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing:nsData)
                
                if let loadedScores = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Scores> {
                    return loadedScores
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    
    
    @IBAction func playAnimation() {
        imageView.startAnimating()
    }
    @IBAction func pauseAnimation() {
        imageView.stopAnimating()
    }
    func startGif(_ imageName: String){
        // 1.获取图片路径。
        guard let filePath = Bundle.main.path(forResource: imageName, ofType: nil) else {
            print("没找到图片资源")
            return
        }
        //根据路径转为data
        guard let fileData = NSData(contentsOfFile: filePath) else { return }
        // 2.根据Data获取CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(fileData, nil) else { return }
        // 3.获取gif图片中图片的个数
        let frameCount = CGImageSourceGetCount(imageSource)
        //获取每一帧图片的时间。
        var duration : TimeInterval = 0
        //图片数组
        var images = [UIImage]()
        for i in 0..<frameCount {
            // 3.1.获取图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            // 3.2.获取时长 每一帧的时间。
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else {continue}
            guard let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary else {continue}
            guard let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else { continue }
            duration += frameDuration.doubleValue
            let image = UIImage(cgImage: cgImage)
            images.append(image)
        }
        // 4.播放图片
        imageView.animationImages = images
        imageView.animationDuration = 5
        //0无限播放。
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    
    
}
