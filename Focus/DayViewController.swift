//
//  DayViewController.swift
//  Focus
//
//  Created by Jeremy Friedland on 6/15/16.
//  Copyright © 2016 Jeremy Friedland. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    //Var for tray
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Tray View Values
        trayDownOffset = 340
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
        
        //Set Tray closed on Load
        trayView.center = trayDown
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            
            trayOriginalCenter = trayView.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            if velocity.y > 0 {
                // move down
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1,  options: [], animations: {
                    () -> Void in self.trayView.center = self.trayDown
                    }, completion: { (Bool) -> Void in
                })
                
            } else {
                // move up
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1,  options: [], animations: {
                    () -> Void in self.trayView.center = self.trayUp
                    }, completion: { (Bool) -> Void in
                })
            }
        }
    }

    
    //Tapping on tray exposes tray
    // Need to add logic for if task = 0 then tray cant be opened
    @IBAction func didTapTray(sender: AnyObject) {
        
        if trayView.center == trayUp {
            // move down
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1,  options: [], animations: {
                () -> Void in self.trayView.center = self.trayDown
                }, completion: { (Bool) -> Void in
            })
            
        } else {
            // move up
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1,  options: [], animations: {
                () -> Void in self.trayView.center = self.trayUp
                }, completion: { (Bool) -> Void in
            })
        }
    }

}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

