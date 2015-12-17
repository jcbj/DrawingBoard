//
//  Board.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/16.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

enum DrawingState {
    case Began, Moved, Ended
}

class Board: UIImageView {

    private var drawingState: DrawingState!
    
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    
    var brush: BaseBrush?
    
    private var realImage: UIImage?
    
    init() {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init(image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.blackColor()
        self.strokeWidth = 1
        
        super.init(coder: aDecoder)
    }
    
    func getFirstTouche(touches: Set<UITouch>) -> UITouch? {
        for touche:UITouch in touches {
            return touche
        }
        
        return nil
    }
    
    //MARK: - touches methods
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush, let touche = self.getFirstTouche(touches) {
            brush.lastPoint = nil
            
            brush.beginPoint = touche.locationInView(self)
            brush.endPoint = brush.beginPoint
            
            self.drawingState = .Began
            self.drawingImage()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush, let touche = self.getFirstTouche(touches) {
            brush.endPoint = touche.locationInView(self)
            
            self.drawingState = .Moved
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let brush = self.brush, let touche = self.getFirstTouche(touches) {
            brush.endPoint = touche.locationInView(self)
            
            self.drawingState = .Ended
            self.drawingImage()
        }
    }
    
    //MARK: - drawingImage
    private func drawingImage() {
        if let brush = self.brush {
            //1.开启一个新的ImageContext，为保存每次的绘图状态作准备
            UIGraphicsBeginImageContext(self.bounds.size)
            
            //2.初始化context，进行基本设置（画笔宽度、画笔颜色、画笔的圆润度等）
            let context = UIGraphicsGetCurrentContext()
            
            UIColor.clearColor().setFill()
            UIRectFill(self.bounds)
            
            CGContextSetLineCap(context, .Round)
            CGContextSetLineWidth(context, self.strokeWidth)
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor)
            
            //3.把之前保存的图片绘制进context中
            if let realImage = self.realImage {
                realImage.drawInRect(self.bounds)
            }
            
            //4.设置brush的基本属性，以便子类更方便的绘图；调用具体的绘图方法，并最终添加到context中
            //TODO:为什么只设置宽度，而没有设置颜色;在画虚线时需要根据线的宽度设置间隔，所以传入，其他地方并不需要，所以颜色不用设置
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context!)
            CGContextStrokePath(context)
            
            //5.从当前的context中，得到Image，如果是ended状态或者需要支持连续不断的绘图，则将Image保存到realImage中
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || brush.supportedContinuousDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            //6.实时显示当前的绘制状态，并记录绘制的最后一个点
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
        }
    }
    
    
    
    
}
