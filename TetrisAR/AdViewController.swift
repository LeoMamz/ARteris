//
//  AdViewController.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/17.
//  Copyright © 2019 Exyte. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    // 用于 AdViewController 销毁后的回调
    var completion: (() -> Void)?
    var adImage: UIImage?
    var adView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if(self.screenHeight < self.screenWidth){
            let temp = self.screenWidth
            self.screenWidth = self.screenHeight
            self.screenWidth = temp
        }
        var adViewHeight = (720 / 1024) * screenWidth
        var imageName = "image"
        if UIDevice.isiPhoneX() {
            adViewHeight = (1124 / 1920) * screenWidth
            imageName = "start_page_x"
        }
        var topC: CGFloat = 250.0
        if(screenWidth < screenHeight){
            adView = UIImageView(frame: CGRect(x: CGFloat(154), y: CGFloat(150), width: screenWidth * 0.6, height: adViewHeight * 0.6))
            topC = 250.0
        }else {
            adView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.6, height: adViewHeight * 0.6))
            topC = 0.0
        }
        adView?.image = UIImage(named: imageName)
        adView?.contentMode = .scaleAspectFill
        self.adView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(adView!)
        let widthContraint = NSLayoutConstraint.init(item: self.adView!,
                                                    attribute: NSLayoutAttribute.width,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: nil,
                                                    attribute: NSLayoutAttribute.notAnAttribute,
                                                    multiplier: CGFloat(0.0),
                                                    constant: CGFloat(screenWidth * 0.6))
        self.adView?.superview?.addConstraint(widthContraint)
        let heightContraint = NSLayoutConstraint.init(item: self.adView!,
                                                     attribute: NSLayoutAttribute.height,
                                                     relatedBy: NSLayoutRelation.equal,
                                                     toItem: nil,
                                                     attribute: NSLayoutAttribute.notAnAttribute,
                                                     multiplier: CGFloat(0.0),
                                                     constant: CGFloat(adViewHeight * 0.6))
        self.adView?.superview?.addConstraint(heightContraint)
        let x = (self.view.frame.size.width - (adView?.frame.size.width)!)/2
        let y = (self.view.frame.size.height - (adView?.frame.size.height)!)/2
        let leftContraint = NSLayoutConstraint.init(item: self.adView!,
                                                    attribute: NSLayoutAttribute.left,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: self.view,
                                                    attribute: NSLayoutAttribute.left,
                                                    multiplier: CGFloat(1.0),
                                                    constant: CGFloat(154.0))
        leftContraint.constant = x
        self.adView?.superview?.addConstraint(leftContraint)
        let rightContraint = NSLayoutConstraint.init(item: self.adView!,
                                                    attribute: NSLayoutAttribute.right,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: self.view,
                                                    attribute: NSLayoutAttribute.right,
                                                    multiplier: CGFloat(1.0),
                                                    constant: CGFloat(154.0))
        rightContraint.constant = y
        self.adView?.superview?.addConstraint(rightContraint)
        let topContraint = NSLayoutConstraint.init(item: adView!,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self.view,
                                                   attribute: .top,
                                                   multiplier: 1.0,
                                                   constant: topC)
        
        self.adView?.superview?.addConstraint(topContraint)
        
        let bottomHolderView = UIView(frame: CGRect(x: 0, y: screenHeight-152, width: screenWidth, height: 152))
        self.view.addSubview(bottomHolderView)
        
        let logo = UIImageView(frame: CGRect(x: (screenWidth-152)/2, y: (52-152)/2, width: 152, height: 152))
        logo.image = UIImage(named: "start_logo")
        bottomHolderView.addSubview(logo)
        
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.dismissAdView()
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissAdView() {
        self.view.removeFromSuperview()
        self.completion?()
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
extension UIDevice {
    public static func isiPhoneX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}
