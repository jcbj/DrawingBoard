//
//  PencilBrush.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/16.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

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
