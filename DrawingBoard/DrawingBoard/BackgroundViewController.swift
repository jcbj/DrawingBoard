//
//  BackgroundViewController.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/10.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var backgroundImageChangedBlock: ((backgroundImage: UIImage) -> Void)?
    var backgroundColorChangedBlock: ((backgroundColor: UIColor) -> Void)?
    
    @IBOutlet weak var pickerImage: UIButton!
    @IBOutlet weak var colorView: UIView!
    var argbColor :ARGBColorPicker!
    
    lazy private var pickerController: UIImagePickerController = {
        [unowned self] in
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        return pickerController
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let colorSetting = UINib(nibName: "ARGBColorPicker", bundle: nil).instantiateWithOwner(nil, options: nil).first as? ARGBColorPicker {
            self.argbColor = colorSetting
            
            self.addConstraintsToColorViewForColorSettingsView(self.argbColor!)
            
            self.argbColor.strokeColorChangedBlock = {
                [unowned self] (strokeColor: UIColor) -> Void in
                if let backgroundColorChangedBlock = self.backgroundColorChangedBlock {
                    backgroundColorChangedBlock(backgroundColor: strokeColor)
                }
            }            
        }
    }
    
    
    func addConstraintsToColorViewForColorSettingsView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.colorView.addSubview(view)
        self.colorView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[settingsView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingsView" : view]))
        
        self.colorView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[settingsView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingsView" : view]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackgroundColor(color: UIColor) {
        if (self.argbColor != nil) {
            self.argbColor?.currentColor = color
        }
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        self.presentViewController(self.pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let backgroundImageChangedBlock = self.backgroundImageChangedBlock {
                backgroundImageChangedBlock(backgroundImage: image)
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
