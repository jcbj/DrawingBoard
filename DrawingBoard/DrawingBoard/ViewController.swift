//
//  ViewController.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/12/16.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var board: Board!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var buttonRedo: UIButton!
    
    var brushes = [PencilBrush(), LineBrush(), DashLineBrush(), RectangleBrush(), EllipseBrush(), EraserBrush()]
    
    var toolbarEditingItems: [UIBarButtonItem]?
    var currentSettingView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.board.brush = brushes[0]
        
        self.board.drawingStateChangedBlock = {
            [unowned self] (state: DrawingState) -> () in
            if state != .Moved {
                UIView.beginAnimations(nil, context: nil)
                //1,同样存在第一次隐藏立即就显示，后面就正常符合预期。但打印的log显示，确实只打印了b，
                if state == .Began {
                    self.buttonRedo.alpha = 0
                    self.buttonUndo.alpha = 0
                    self.topView.alpha = 0
                    self.toolbar.alpha = 0
                    
                } else if state == .Ended {
                    UIView.setAnimationDelay(0.5)
                    
                    self.buttonRedo.alpha = 1
                    self.buttonUndo.alpha = 1
                    self.topView.alpha = 1
                    self.toolbar.alpha = 1
                }
                
                UIView.commitAnimations()
            }
        }
        
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "endSetting")
        ]
        //UIViewController自带
        self.toolbarItems = self.toolbar.items
        
        self.setupBrushSettingView()
        self.setupBackgroundSettingView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchBrush(sender: UISegmentedControl) {
        assert(sender.tag < self.brushes.count, "!!!")
        
        self.board.brush = self.brushes[sender.selectedSegmentIndex]
    }

    @IBAction func paintingBrushSettings(sender: AnyObject) {
        self.currentSettingView = self.toolbar.viewWithTag(1)
        self.currentSettingView?.hidden = false
        
        self.updateToolbarForSettingView()
    }
    
    @IBAction func backgroundSettings(sender: AnyObject) {
        self.currentSettingView = self.toolbar.viewWithTag(2)
        self.currentSettingView?.hidden = false
        
        self.updateToolbarForSettingView()
    }
    
    @IBAction func saveImage(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(self.board.takeImage(), self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafePointer<Void>) {
        if let err = error {
            UIAlertView(title: "错误", message: err.localizedDescription, delegate: nil, cancelButtonTitle: "确定").show()
        } else {
            UIAlertView(title: "提示", message: "保存成功", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    func updateToolbarForSettingView() {
        self.toolbarConstraintHeight.constant = self.currentSettingView!.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 44
        
        self.toolbar.setItems(self.toolbarEditingItems, animated: true)
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.toolbar.bringSubviewToFront(self.currentSettingView!)
    }
    
    func setupBrushSettingView() {
        if let brushSettingView = UINib(nibName: "PaintingBrushSettingView", bundle: nil).instantiateWithOwner(nil, options: nil).first as? PaintingBrushSettingView {
            
            self.addConstraintsToToolbarForSettingView(brushSettingView)
            
            brushSettingView.hidden = true
            brushSettingView.tag = 1
            brushSettingView.setCurrentColor(self.board.strokeColor)
            brushSettingView.setCurrentWidth(self.board.strokeWidth)
            
            brushSettingView.strokeColorChangedBlock = {
                [unowned self] (strokeColor: UIColor) in
                self.board.strokeColor = strokeColor
            }
            
            brushSettingView.strokeWidthChangedBlock = {
                [unowned self] (strokeWidth: CGFloat) in
                self.board.strokeWidth = strokeWidth
            }
        }
    }
    
    func setupBackgroundSettingView() {
        if let backgroundSettingVC = UINib(nibName: "BackgroundSettingVC", bundle: nil).instantiateWithOwner(nil, options: nil).first as? BackgroundSettingVC {
            self.addConstraintsToToolbarForSettingView(backgroundSettingVC.view)
            
            backgroundSettingVC.view.hidden = true
            backgroundSettingVC.view.tag = 2
            backgroundSettingVC.setCurrentColor(self.board.backgroundColor!)
            
            self.addChildViewController(backgroundSettingVC)
            
            backgroundSettingVC.backgroundColorChangedBlock = {
                [unowned self] (color: UIColor) in
                self.board.backgroundColor = color
            }
            
            backgroundSettingVC.backgroundImageChangedBlock = {
                [unowned self] (image: UIImage) in
                self.board.backgroundColor = UIColor(patternImage: image)
            }
        }
    }
    
    func addConstraintsToToolbarForSettingView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.toolbar.addSubview(view)
        
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[settingView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["settingView" : view]))
        
        self.toolbar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[settingView(==height)]",
            options: .DirectionLeadingToTrailing,
            metrics: ["height" : view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height],
            views: ["settingView" : view]))
    }
    
    @IBAction func endSetting() {
        self.toolbarConstraintHeight.constant = 44
        
        self.toolbar.setItems(self.toolbarItems, animated: true)
        
        UIView.beginAnimations(nil, context: nil)
        self.toolbar.layoutIfNeeded()
        UIView.commitAnimations()
        
        self.currentSettingView?.hidden = true
    }
    
    @IBAction func undo(sender: AnyObject) {
        self.board.undo()
    }
    
    @IBAction func redo(sender: AnyObject) {
        self.board.redo()
    }
}

