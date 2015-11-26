//
//  BaseBrush.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/11/26.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import CoreGraphics

protocol PaintBrush {
    /**
     是否上连续不断的绘图
     
     - returns: <#return value description#>
     */
    func supportedContinuousDrawing() -> Bool
    
    /**
     基于context的绘图方法，子类必须实现具体的绘图
     
     - parameter context: <#context description#>
     */
    func drawInContext(context: CGContextRef)
}

/// 绘图类的基类
class BaseBrush: NSObject, PaintBrush {

    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    /// 最后一个点的位置，或者上一个点的位置
    var lastPoint: CGPoint!
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(context: CGContextRef) {
        assert(false,"must implements in subclass.")
    }
}

class PencilBrush: BaseBrush {
    
    override func drawInContext(context: CGContextRef) {
        if let lastPoint = self.lastPoint {
            CGContextMoveToPoint(context, lastPoint.x, lastPoint.y)
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        } else {
            CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
        }
    }
    
    override func supportedContinuousDrawing() -> Bool {
        return true
    }
}

class LineBrush: BaseBrush {
    
    override func drawInContext(context: CGContextRef) {
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
    }
}

class DashLineBrush: BaseBrush {
    
    override func drawInContext(context: CGContextRef) {
        let lengths: [CGFloat] = [self.strokeWidth * 3, self.strokeWidth * 3]
        CGContextSetLineDash(context, 0, lengths, 2)
        
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
    }
}

class RectangleBrush: BaseBrush {
    
    override func drawInContext(context: CGContextRef) {
        CGContextAddRect(context, CGRect(origin: CGPoint(x: min(beginPoint.x,endPoint.x), y: min(beginPoint.y, endPoint.y)), size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}

class EllipseBrush: BaseBrush {
    
    override func drawInContext(context: CGContextRef) {
        CGContextAddEllipseInRect(context, CGRect(origin: CGPoint(x: min(beginPoint.x,endPoint.x), y: min(beginPoint.y, endPoint.y)), size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}

/// 橡皮擦的实现其实就是把画笔颜色设置为背景色，但是如果背景色可以动态设置，甚至设置为一个渐变的图片时，这种方法就失效了，所以有些绘图app的背景色就是固定为白色的。
class EraserBrush: PencilBrush {
    
    override func drawInContext(context: CGContextRef) {
        //加入这一句代码，一个真正的橡皮擦便实现了;
        //混合两种颜色
        CGContextSetBlendMode(context, .Clear)
        
        super.drawInContext(context)
    }
}













