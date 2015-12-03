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
    
    @IBOutlet weak var toolar: UIToolbar!
    @IBOutlet weak var toolarHeightConstraint: NSLayoutConstraint!
    
    var toolbarEditingItems: [UIBarButtonItem]?
    var currentSettingsView: UIView?
    
    var brushes = [PencilBrush(),LineBrush(),DashLineBrush(),RectangleBrush(),EllipseBrush(),EraserBrush()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.board.brush = self.brushes[0]
        
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "endSetting")
        ]
        
        self.toolbarItems = self.toolar.items
        
        self.setupBrushSettingsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchBrush(sender: UISegmentedControl) {
        assert(sender.selectedSegmentIndex < self.brushes.count,"No Implementation of This Tool")
        
        self.board.brush = self.brushes[sender.selectedSegmentIndex]
    }

    @IBAction func paintingBrushSettings(sender: UIBarButtonItem) {
        self.currentSettingsView = self.toolar.viewWithTag(1)
        if nil != self.currentSettingsView {
            
            self.currentSettingsView?.hidden = false
            
            self.updateToolbarForSettingsView()
        }
    }
    
    func updateToolbarForSettingsView() {
        //自动计算的高度为零
        self.toolarHeightConstraint.constant = self.currentSettingsView!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 44
        print("\(self.currentSettingsView!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height)")
        
        self.toolar.setItems(self.toolbarEditingItems, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.toolar.bringSubviewToFront(self.currentSettingsView!)
    }
    
    @IBAction func endSetting() {
        self.toolarHeightConstraint.constant = 44
        
        self.toolar.setItems(self.toolbarItems, animated: true)
        
        UIView.beginAnimations(nil, context: nil)
        self.toolar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.currentSettingsView?.hidden = true
    }
    
    func addConstraintsToToolbarForSettingsView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.toolar.addSubview(view)
        self.toolar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[settingsView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingsView" : view]))
        self.toolar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[settingsView(==height)]",
            options: .DirectionLeadingToTrailing,
            metrics: ["height" : view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height],
            views: ["settingsView" : view]))
    }
    
    func setupBrushSettingsView() {
        if let brushSettingsView = UINib(nibName: "PaintingBrushSettingsView",
            bundle: nil).instantiateWithOwner(nil,
                options: nil).first as? PaintingBrushSettingsView {
                    self.addConstraintsToToolbarForSettingsView(brushSettingsView)
                    
                    brushSettingsView.hidden = true
                    brushSettingsView.tag = 1
                    brushSettingsView.backgroundColor = UIColor.clearColor()
                    brushSettingsView.penColor = self.board.strokeColor
                    brushSettingsView.penWidth = self.board.strokeWidth
                    
                    brushSettingsView.strokeColorChangedBlock = {
                        [unowned self] (strokeColor: UIColor) -> Void in
                        self.board.strokeColor = strokeColor
                    }
                    
                    brushSettingsView.strokeWidthChangedBlock = {
                        [unowned self] (strokeWidth: Int) -> Void in
                        self.board.strokeWidth = strokeWidth
                    }
        }
    }
    
}

