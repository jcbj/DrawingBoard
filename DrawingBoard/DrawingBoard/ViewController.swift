//
//  ViewController.swift
//  DrawingBoard
//
//  Created by jiangchao on 15/11/25.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topToolbarView: UIView!
    @IBOutlet weak var board: Board!
    
    @IBOutlet weak var toolar: UIToolbar!
    @IBOutlet weak var toolarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    var toolbarEditingItems: [UIBarButtonItem]?
    var currentSettingsView: UIView?
    
    
    var brushes = [PencilBrush(),LineBrush(),DashLineBrush(),RectangleBrush(),EllipseBrush(),EraserBrush()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.board.brush = self.brushes[0]
        
        self.board.drawingStateChangedBlock = {
            [unowned self] (state: DrawingState) -> () in
            if state != DrawingState.Moved {
                
                UIView.beginAnimations(nil, context: nil)
                
//                print("I")
                
                //TODO:启动以后第一次画时，工具条不能隐藏，调试发现代码执行了，但是界面似乎没有刷新。
                if state == .Began {
                    self.topToolbarView.center.y = -self.topToolbarView.center.y
                    self.toolar.center.y = self.toolar.center.y + self.toolar.bounds.size.height
                    
                    self.topToolbarView.layoutIfNeeded()
                    self.toolar.layoutIfNeeded()
                    
                    self.undoButton.alpha = 0
                    self.redoButton.alpha = 0
                    
//                    print("B \(self.topToolbarView.center.y) \(self.toolar.center.y)")
                } else if state == .Ended {
                    UIView.setAnimationDelay(0.5)
                    
                    self.topToolbarView.center.y = self.topToolbarView.bounds.size.height / 2.0
                    self.toolar.center.y = self.view.bounds.height - self.toolar.bounds.size.height / 2.0
                    
                    self.topToolbarView.layoutIfNeeded()
                    self.toolar.layoutIfNeeded()
                    
                    self.undoButton.alpha = 1
                    self.redoButton.alpha = 1
                    
                    self.undoButton.enabled = self.board.canUndo
                    self.redoButton.enabled = self.board.canRedo
                    
//                    print("E")
                }
                
                UIView.commitAnimations()
//                print("L")
            }
        }
        
        self.toolbarEditingItems = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "endSetting")
        ]
        
        self.toolbarItems = self.toolar.items
        
        self.setupBrushSettingsView()
        self.setupBackgroundSettingsView()
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
    
    func setupBackgroundSettingsView() {
        if let backgroundSettingsVC = UINib(nibName: "BackgroundViewController", bundle: nil).instantiateWithOwner(nil, options: nil).first as? BackgroundViewController {
            
            self.addConstraintsToToolbarForSettingsView(backgroundSettingsVC.view)
            
            backgroundSettingsVC.view.hidden = true
            backgroundSettingsVC.view.tag = 2
            backgroundSettingsVC.setBackgroundColor(self.board.backgroundColor!)
            
            self.addChildViewController(backgroundSettingsVC)
            
            backgroundSettingsVC.backgroundImageChangedBlock = {
                [unowned self] (backgroundImage: UIImage) in
                self.board.backgroundColor = UIColor(patternImage: backgroundImage)
            }

            backgroundSettingsVC.backgroundColorChangedBlock = {
                [unowned self] (backgroundColor: UIColor) in
                self.board.backgroundColor = backgroundColor
            }            
        }
    }
    
    @IBAction func backgroundSettings(sender: AnyObject) {
        self.currentSettingsView = self.toolar.viewWithTag(2)
        self.currentSettingsView?.hidden = false
        
        self.updateToolbarForSettingsView()
    }
    
    @IBAction func saveToAlbumy(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(self.board.takeImage(), self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if let err = error {
            UIAlertView(title: "错误", message: err.localizedDescription, delegate: nil, cancelButtonTitle: "确定").show()
        } else {
            UIAlertView(title: "提示", message: "保存成功", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    //TODO:按钮不可用时，在按钮上点击以后，直接就画图了。个人觉得这时应该什么也不做才和逻辑。
    @IBAction func undo(sender: AnyObject) {
        self.board.undo()
        
        self.undoButton.enabled = self.board.canUndo
        self.redoButton.enabled = self.board.canRedo
    }
    
    @IBAction func redo(sender: AnyObject) {
        self.board.redo()
        
        self.undoButton.enabled = self.board.canUndo
        self.redoButton.enabled = self.board.canRedo
    }
}

