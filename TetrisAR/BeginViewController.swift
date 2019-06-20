//
//  BeginViewController.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/16.
//  Copyright © 2019 Exyte. All rights reserved.
//

import UIKit

class BeginViewController: UIViewController {
    private var advertiseView: UIView?
    var adView: UIView? {
        didSet {
            advertiseView = adView!
            advertiseView?.frame = self.view.bounds
            self.view.addSubview(advertiseView!)
            if(UIScreen.main.bounds.width > 800){
                startGifForimageView(images[5], advertiseView?.subviews[0] as! UIImageView)
            }else {
                startGifForimageView(images[5], advertiseView?.subviews[0] as! UIImageView)
            }
            
            UIView.animate(withDuration: 6, animations: { [weak self] in
                self?.advertiseView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self?.advertiseView?.alpha = 0
            }) { [weak self] (isFinish) in
                self?.advertiseView?.removeFromSuperview()
                self?.advertiseView = nil
            }
        }
    }
    func startGifForimageView(_ imageName: String, _ imageView: UIImageView){
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
    
    @IBOutlet weak var imageView: UIImageView!
    var images: Array<String> = ["begin.gif","1.gif","2.gif","3.gif","4.gif", "229.gif","229-960.gif"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        startGif(self.images[3])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
