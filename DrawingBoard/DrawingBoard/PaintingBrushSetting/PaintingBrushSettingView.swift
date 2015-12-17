//
//  PaintingBrushSettingView.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/17.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class PaintingBrushSettingView: UIView ,UITextFieldDelegate{

    @IBOutlet weak var tfWidth: UITextField!
    @IBOutlet weak var sliderWidth: UISlider!
    @IBOutlet weak var displayWidthHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelDisplayWidth: UILabel!
    var strokeWidthChangedBlock: ((strokeWidth: CGFloat) -> Void)?
    var strokeColorChangedBlock: ((strokeColor: UIColor) -> Void)?
    
    var argbColorPicker: ARGBColorPicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addARGBColorToPaintingView()
        
        self.tfWidth.delegate = self
    }
    
    func addARGBColorToPaintingView() {
        
        if let argbColorPicker = UINib(nibName: "ARGBColorPicker", bundle: nil).instantiateWithOwner(nil, options: nil).first as? ARGBColorPicker {
            
            self.argbColorPicker = argbColorPicker
            
            self.argbColorPicker.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(self.argbColorPicker)
            
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[colorView]-0-|",
                options: .DirectionLeadingToTrailing,
                metrics: nil,
                views: ["colorView" : self.argbColorPicker]))
            
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sliderWidth]-8-[colorView]-8-|",
                options: .DirectionLeadingToTrailing,
                metrics: nil,
                views: ["colorView": self.argbColorPicker,
                    "sliderWidth" : self.sliderWidth]))
            
            self.argbColorPicker.currentColorChangedBlock = {
                [unowned self] (currentColor: UIColor) -> Void in
                if let strokeColorChangedBlock = self.strokeColorChangedBlock {
                    strokeColorChangedBlock(strokeColor: currentColor)
                    self.labelDisplayWidth.backgroundColor = currentColor
                }
            }
        }
    }
    
    func setCurrentColor(currentColor: UIColor) {
        if let argbColorPicker = self.argbColorPicker {
            argbColorPicker.currentColor = currentColor
            self.labelDisplayWidth.backgroundColor = currentColor
        }
    }
    
    func setCurrentWidth(currentWidth: CGFloat) {
        self.displayWidthHeightConstraint.constant = currentWidth
        self.tfWidth.text = String(currentWidth)
        self.sliderWidth.value = Float(currentWidth)
    }    
    
    @IBAction func sliderWidthValueChanged(sender: UISlider) {
        let width = Int(self.sliderWidth.value)
        
        self.displayWidthHeightConstraint.constant = CGFloat(width)
        
        self.tfWidth.text = String(width)
        
        if let strokeWidthChangedBlock = self.strokeWidthChangedBlock {
            strokeWidthChangedBlock(strokeWidth: CGFloat(width))
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = self.tfWidth.text, let width = Int(text) {
            self.sliderWidth.value = Float(width)
            self.displayWidthHeightConstraint.constant = CGFloat(width)
            
            if let strokeWidthChangedBlock = self.strokeWidthChangedBlock {
                strokeWidthChangedBlock(strokeWidth: CGFloat(width))
            }            
        }
        
        return true
    }
    
}
