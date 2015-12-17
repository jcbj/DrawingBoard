//
//  ARGBColorPicker.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/4.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class ARGBColorPicker: UIView ,UITextFieldDelegate{

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDisplayColor: UILabel!
    
    @IBOutlet weak var sliderA: UISlider!
    @IBOutlet weak var tfA: UITextField!
    
    @IBOutlet weak var sliderR: UISlider!
    @IBOutlet weak var tfR: UITextField!
    
    @IBOutlet weak var sliderG: UISlider!
    @IBOutlet weak var tfG: UITextField!
    
    @IBOutlet weak var sliderB: UISlider!
    @IBOutlet weak var tfB: UITextField!
    
    var currentColorChangedBlock: ((strokeColor: UIColor) -> Void)?
    
    var title: String = "当前颜色" {
        didSet {
            self.labelTitle.text = title
        }
    }    
    
    /// 当前颜色
    var currentColor: UIColor = UIColor.blackColor() {
        didSet {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            if currentColor.getRed(&r,
                green: &g,
                blue: &b,
                alpha: &a) {
                    self.sliderA.value = Float(Int(a * 255))
                    self.sliderR.value = Float(Int(r * 255))
                    self.sliderG.value = Float(Int(g * 255))
                    self.sliderB.value = Float(Int(b * 255))
                    
                    self.tfA.text = String(Int(a * 255))
                    self.tfR.text = String(Int(r * 255))
                    self.tfG.text = String(Int(g * 255))
                    self.tfB.text = String(Int(b * 255))
                    
                    self.labelDisplayColor.backgroundColor = self.currentColor
            }
        }
    }

    override func awakeFromNib() {
        self.tfA.delegate = self
        self.tfR.delegate = self
        self.tfG.delegate = self
        self.tfG.delegate = self
    }
    
    func changedCurrentColor() {
        self.currentColor = UIColor(
            red: CGFloat(Float(Int(self.sliderR.value)) / 255.0),
            green: CGFloat(Float(Int(self.sliderG.value)) / 255.0),
            blue: CGFloat(Float(Int(self.sliderB.value)) / 255.0),
            alpha: CGFloat(Float(Int(self.sliderA.value)) / 255.0))
        
        if let currentColorChanged = self.currentColorChangedBlock {
            currentColorChanged(strokeColor: self.currentColor)
        }
    }
    
    @IBAction func sliderAValueChanged(sender: AnyObject) {
        self.tfA.text = String(Int(self.sliderA.value))
        self.changedCurrentColor()
    }
    
    @IBAction func sliderRValueChanged(sender: AnyObject) {
        self.tfR.text = String(Int(self.sliderR.value))
        self.changedCurrentColor()
    }
    
    @IBAction func sliderGValueChanged(sender: AnyObject) {
        self.tfG.text = String(Int(self.sliderG.value))
        self.changedCurrentColor()
    }
    
    @IBAction func sliderBValueChanged(sender: AnyObject) {
        self.tfB.text = String(Int(self.sliderB.value))
        self.changedCurrentColor()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        switch textField {
        case self.tfA:
            if let text = self.tfA.text, let value = Int(text) {
                self.sliderA.value = Float(value)
                self.changedCurrentColor()
            }
        case self.tfR:
            if let text = self.tfR.text, let value = Int(text) {
                self.sliderR.value = Float(value)
                self.changedCurrentColor()
            }
        case self.tfG:
            if let text = self.tfG.text, let value = Int(text) {
                self.sliderG.value = Float(value)
                self.changedCurrentColor()
            }
        case self.tfB:
            if let text = self.tfB.text, let value = Int(text) {
                self.sliderB.value = Float(value)
                self.changedCurrentColor()
            }
        default:
            break
        }
        
        return true
    }
    
}
