//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Pann Cherry on 10/15/18.
//  Copyright © 2018 TechBloomer. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var trayView: UIView!
    
    // MARK: Properties
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    var isArrowFacingUp = false
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffset = 160
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCanvas(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: - IBActions
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        _ = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            if velocity.y > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            } else {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            }
        }
    }
    
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            newlyCreatedFace.isUserInteractionEnabled = true
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch))
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotated))
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteSmileys))
            newlyCreatedFace.addGestureRecognizer(doubleTapRecognizer)
            
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
        }
    }
    
    
    // MARK: - Helper Functions
    @objc func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            newlyCreatedFace = sender.view as? UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
            
            UIView.animate(withDuration:0.4, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            UIView.animate(withDuration:0.4, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    @objc func didPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        // let imageView = sender.view as! UIImageView
        newlyCreatedFace.transform = CGAffineTransform(scaleX: scale, y: scale)
        sender.scale = 1
    }
    
    @objc func didRotated(_ sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        print("did rotate")
        newlyCreatedFace.transform = newlyCreatedFace.transform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    @objc func deleteSmileys(sender: UITapGestureRecognizer) {
        let faceView = sender.view as! UIImageView
        faceView.removeFromSuperview()
    }
    
    @objc func didDoubleTapCanvas(sender: UITapGestureRecognizer) {
        for case let faceView as UIImageView in self.view.subviews {
            faceView.removeFromSuperview()
        }
    }
    
}
