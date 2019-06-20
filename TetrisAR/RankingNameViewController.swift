//
//  RankingNameViewController.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/17.
//  Copyright © 2019 Exyte. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import os.log

class RankingNameViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    var score = 0
    var scores = [Scores]()
    var rank: Scores?
    var images: Array<String> = ["begin.gif","1.gif","2.gif","3.gif","4.gif"]
    @IBOutlet weak var rankingName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        rankingName.delegate = self

        //gif
        startGif(self.images[0])
        
        // Do any additional setup after loading the view.
        let savedScores = loadScores()
        
        if savedScores?.count ?? 0 > 0 {
            self.scores = savedScores ?? [Scores]()
        }else{
            
        }
    }
    
    @IBAction func saveRank(_ sender: UIButton) {
        let nameText = self.rankingName.text ?? "未输入"
        guard let dataTemp = Scores(score: self.score, name: nameText) else {
            print("请输入text数据")
            return
        }
        self.scores.append(dataTemp)
        print(nameText)
        self.scores.sort(by: {$0.score > $1.score})
        saveScores()
        returnToRankingList()
    }
    
    func returnToBegin() {
        //let vc = GameSetViewController()
        //self.present(vc, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "BeginViewController") as? BeginViewController else {  return }
        self.present(secondVC, animated: true, completion: nil)
    }
    func returnToRankingList() {
        //let vc = GameSetViewController()
        //self.present(vc, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "RankingListTableViewController") as? RankingListTableViewController else {  return }
        self.present(secondVC, animated: true, completion: nil)
    }
    /*
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateSaveButtonState()
        //navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        
    }
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        //let text = self.rankingName.text ?? ""
        
    }
    */
    //save and load
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
    
    //gif
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        
        
        let name = self.rankingName.text ?? ""
        let score = self.score
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        rank = Scores(score: score, name: name)
    }

}
