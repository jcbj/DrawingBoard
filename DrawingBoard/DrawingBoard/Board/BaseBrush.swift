//
//  BaseBrush.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/16.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit
//import CoreGraphics

protocol PaintBrush {
    //是否连续画图，例如铅笔工具
    func supportedContinuousDrawing() -> Bool
    
    func drawInContext(context: CGContextRef)
}

class BaseBrush: NSObject, PaintBrush {
    
    var beginPoint: CGPoint!
    var endPoint: CGPoint!
    var lastPoint: CGPoint?
    
    var strokeWidth: CGFloat!
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(context: CGContextRef) {
        assert(false, "must implements in subclass.")
    }

}
