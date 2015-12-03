//
//  PaintingBrushSettingsView.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/2.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class PaintingBrushSettingsView: UIView,UITextFieldDelegate {

    var strokeWidthChangedBlock: ((strokeWidth: Int) -> Void)?
    var strokeColorChangedBlock: ((strokeColor: UIColor) -> Void)?
    
    var penWidth: Int = 1 {
        didSet {
            self.heightPenWidthConstraint.constant = CGFloat(penWidth)
            
            self.sliderPenWidth.value = Float(penWidth)
            self.tfPenWidth.text = String(penWidth)
        }
    }
    
    /// 当前画笔颜色
    var penColor: UIColor = UIColor.blackColor() {
        didSet {
            self.labelPenColor.backgroundColor = penColor
            self.labelPenWidth.backgroundColor = penColor
            
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            if penColor.getRed(&r,
                green: &g,
                blue: &b,
                alpha: &a) {
                    self.sliderAPenColor.value = Float(Int(a * 255))
                    self.sliderRPenColor.value = Float(Int(r * 255))
                    self.sliderGPenColor.value = Float(Int(g * 255))
                    self.sliderBPenColor.value = Float(Int(b * 255))
                    
                    self.tfAPenColor.text = String(Int(a * 255))
                    self.tfRPenColor.text = String(Int(r * 255))
                    self.tfGPenColor.text = String(Int(g * 255))
                    self.tfBPenColor.text = String(Int(b * 255))
            }
        }
    }
    
    @IBOutlet weak var labelPenWidth: UILabel!
    @IBOutlet weak var heightPenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderPenWidth: UISlider!
    @IBOutlet weak var tfPenWidth: UITextField!
    
    @IBOutlet weak var labelPenColor: UILabel!
    
    @IBOutlet weak var sliderAPenColor: UISlider!
    @IBOutlet weak var tfAPenColor: UITextField!
    
    @IBOutlet weak var sliderRPenColor: UISlider!
    @IBOutlet weak var tfRPenColor: UITextField!
    
    @IBOutlet weak var sliderGPenColor: UISlider!
    @IBOutlet weak var tfGPenColor: UITextField!
    
    @IBOutlet weak var sliderBPenColor: UISlider!
    @IBOutlet weak var tfBPenColor: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tfPenWidth.delegate = self
        self.tfAPenColor.delegate = self
        self.tfRPenColor.delegate = self
        self.tfGPenColor.delegate = self
        self.tfGPenColor.delegate = self
    }
    
    @IBAction func sliderPenWidthValueChanged(sender: AnyObject) {
        self.penWidth = Int(self.sliderPenWidth.value)
        if let strokeWidthChanged = self.strokeWidthChangedBlock {
            strokeWidthChanged(strokeWidth: self.penWidth)
        }
    }
    
    @IBAction func sliderAPenColorValueChanged(sender: AnyObject) {
        self.tfAPenColor.text = String(Int(self.sliderAPenColor.value))
        self.changedCurrentColor()
    }
    
    @IBAction func sliderRPenColorValueChanged(sender: AnyObject) {
        self.tfRPenColor.text = String(Int(self.sliderRPenColor.value))
        self.changedCurrentColor()
    }
    
    @IBAction func sliderGPenColorValueChanged(sender: AnyObject) {
        self.tfGPenColor.text = String(Int(self.sliderGPenColor.value))
        self.changedCurrentColor()
    }
    
    @IBAction func sliderBPenColorValueChanged(sender: AnyObject) {
        self.tfBPenColor.text = String(Int(self.sliderBPenColor.value))
        self.changedCurrentColor()
    }
    
    func changedCurrentColor() {
        self.penColor = UIColor(
            red: CGFloat(Float(Int(self.sliderRPenColor.value)) / 255.0),
            green: CGFloat(Float(Int(self.sliderGPenColor.value)) / 255.0),
            blue: CGFloat(Float(Int(self.sliderBPenColor.value)) / 255.0),
            alpha: CGFloat(Float(Int(self.sliderAPenColor.value)) / 255.0))
        
        if let strokeColorChanged = self.strokeColorChangedBlock {
            strokeColorChanged(strokeColor: self.penColor)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case self.tfPenWidth:
            if let text = self.tfPenWidth.text, let value = Int(text) {
                self.penWidth = value
            }
        case self.tfAPenColor:
            if let text = self.tfAPenColor.text, let value = Int(text) {
                self.sliderAPenColor.value = Float(value)
                self.changedCurrentColor()
            }
        case self.tfRPenColor:
            if let text = self.tfRPenColor.text, let value = Int(text) {
                self.sliderRPenColor.value = Float(value)
                self.changedCurrentColor()
            }
        case self.tfGPenColor:
            if let text = self.tfGPenColor.text, let value = Int(text) {
                self.sliderGPenColor.value = Float(value)
                self.changedCurrentColor()
            }
        case self.tfBPenColor:
            if let text = self.tfBPenColor.text, let value = Int(text) {
                self.sliderBPenColor.value = Float(value)
                self.changedCurrentColor()
            }
        default:
            break
        }
        
        return true
    }
}
