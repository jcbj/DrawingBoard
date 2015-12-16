//
//  EraserBrush.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/16.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

//注意此处继承与铅笔工具
class EraserBrush: PencilBrush {
    
    override func drawInContext(context: CGContextRef) {
        CGContextSetBlendMode(context, .Clear)
        
        super.drawInContext(context)
    }

}
