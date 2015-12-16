//
//  DashLineBrush.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/16.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class DashLineBrush: BaseBrush {
    
    override func drawInContext(context: CGContextRef) {
        let lengths: [CGFloat] = [self.strokeWidth * 3, self.strokeWidth * 3]
        CGContextSetLineDash(context, 0, lengths, 2)
        
        CGContextMoveToPoint(context, beginPoint.x, beginPoint.y)
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
    }

}
