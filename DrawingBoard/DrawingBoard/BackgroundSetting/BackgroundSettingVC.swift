//
//  BackgroundSettingVC.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/18.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class BackgroundSettingVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var buttonPickerImage: UIButton!
    
    var backgroundImageChangedBlock: ((image: UIImage) -> Void)?
    var backgroundColorChangedBlock: ((color: UIColor) -> Void)?
    
    var argbColorPicker: ARGBColorPicker!
    
    lazy private var pickerController: UIImagePickerController = {
       [unowned self] in
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        return pickerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addARGBColorToPaintingView()
    }
    
    func addARGBColorToPaintingView() {
        
        if let argbColorPicker = UINib(nibName: "ARGBColorPicker", bundle: nil).instantiateWithOwner(nil, options: nil).first as? ARGBColorPicker {
            
            self.argbColorPicker = argbColorPicker
            
            self.argbColorPicker.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(self.argbColorPicker)
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[colorView]-0-|",
                options: .DirectionLeadingToTrailing,
                metrics: nil,
                views: ["colorView" : self.argbColorPicker]))
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[buttonPickerImage]-8-[colorView]-8-|",
                options: .DirectionLeadingToTrailing,
                metrics: nil,
                views: ["colorView": self.argbColorPicker,
                    "buttonPickerImage" : self.buttonPickerImage]))
            
            self.argbColorPicker.currentColorChangedBlock = {
                [unowned self] (currentColor: UIColor) -> Void in
                if let backgroundColorChangedBlock = self.backgroundColorChangedBlock {
                    backgroundColorChangedBlock(color: currentColor)
                }
            }
        }
    }
    
    func setCurrentColor(currentColor: UIColor) {
        if let argbColorPicker = self.argbColorPicker {
            argbColorPicker.currentColor = currentColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickerImage(sender: AnyObject) {
        self.presentViewController(self.pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let backgroundImageChangedBlock = self.backgroundImageChangedBlock {
                backgroundImageChangedBlock(image: image)
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
