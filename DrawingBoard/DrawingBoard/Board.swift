//
//  Board.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/11/25.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

enum DrawingState {
    case Began, Moved, Ended
}

class Board: UIImageView {
    
    var drawingStateChangedBlock : ((drawingState: DrawingState) -> ())?

    var drawingState: DrawingState!
    
    var strokeWidth: Int
    var strokeColor: UIColor
    
    var brush: BaseBrush?
    var realImage: UIImage?
    
    private var undoImages = [UIImage]()
    private var redoImages = [UIImage]()
    
    init() {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init(image: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init(coder: aDecoder)!
    }
    
    //MARK: - touches methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush {
            if let touche = self.getFirstTouche(touches) {
                
                brush.lastPoint = nil
                brush.beginPoint = touche.locationInView(self)
                brush.endPoint = brush.beginPoint
                
                self.drawingState = .Began
                self.drawingImage()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush {
            if let touche = self.getFirstTouche(touches) {
                brush.endPoint = touche.locationInView(self)
                
                self.drawingState = .Moved
                self.drawingImage()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if let brush = self.brush {
            if let touche = self.getFirstTouche(touches) {
                brush.endPoint = touche.locationInView(self)
                
                self.drawingState = .Ended
                self.drawingImage()
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    func getFirstTouche(touches: Set<UITouch>) -> UITouch? {
        for touche:UITouch in touches {
            return touche
        }
        
        return nil
    }
    
    func takeImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        
        self.image?.drawInRect(self.bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //MARK: - drawing
    func drawingImage() {
        if let brush = self.brush {
            
            if let drawingStateChangedBlock = self.drawingStateChangedBlock {
                drawingStateChangedBlock(drawingState: self.drawingState)
            }
            
            //1,开启一个新的ImageContext，为保存每次的绘图状态作准备
            UIGraphicsBeginImageContext(self.bounds.size)
            
            //2,初始化context，进行基本设置（画笔宽度、画笔颜色、画笔的圆润度等）
            let context = UIGraphicsGetCurrentContext()
            
            UIColor.clearColor().setFill()
            UIRectFill(self.bounds)
            
            CGContextSetLineCap(context, .Round)
            CGContextSetLineWidth(context, CGFloat(self.strokeWidth))
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor)
            
            //3,把之前保存的图片绘制进context中
            if let realImage = self.realImage {
                realImage.drawInRect(self.bounds)
            }
            
            //4,设置brush的基本属性，以便子类更方便的绘图；调用具体的绘图方法，并最终添加到context中
            brush.strokeWidth = CGFloat(self.strokeWidth)
            brush.drawInContext(context!)
            CGContextStrokePath(context)
            
            //5,从当前的context中，得到Image，如果是ended状态或者需要支持连续不断的绘图，则将Image保存到realImage中
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || brush.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            //Undo and Redo
            if self.drawingState == DrawingState.Began {
                self.redoImages = []
                
                if nil != self.image {
                    self.undoImages.append(self.image!)
                }
            }
            
            //6,实时显示当前的绘制状态，并记录绘制的最后一个点
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
        }
    }
    
    //MARK: - Undo / Redo
    var canUndo: Bool {
        get {
            return self.undoImages.count > 0 || self.image != nil
        }
    }
    
    var canRedo: Bool {
        get {
            return self.redoImages.count > 0
        }
    }
    
    func undo() {
        if self.canUndo == false {
            return
        }
        
        if self.undoImages.count > 0 {
            self.redoImages.append(self.image!)
            
            let lastImage = self.undoImages.removeLast()
            self.image = lastImage
        } else if self.image != nil {
            self.redoImages.append(self.image!)
            self.image = nil
        }
        
        self.realImage = self.image
    }
    
    func redo() {
        if false == self.canRedo {
            return
        }
        
        if self.redoImages.count > 0 {
            if nil != self.image {
                self.undoImages.append(self.image!)
            }
            
            let lastImage = self.redoImages.removeLast()
            self.image = lastImage
            
            self.realImage = self.image
        }
    }
}














