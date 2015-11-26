//
//  ViewController.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/11/25.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var board: Board!
    
    var brushes = [PencilBrush(),LineBrush(),DashLineBrush(),RectangleBrush(),EllipseBrush(),EraserBrush()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.board.brush = self.brushes[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchBrush(sender: UISegmentedControl) {
        assert(sender.selectedSegmentIndex < self.brushes.count,"No Implementation of This Tool")
        
        self.board.brush = self.brushes[sender.selectedSegmentIndex]
    }

}

