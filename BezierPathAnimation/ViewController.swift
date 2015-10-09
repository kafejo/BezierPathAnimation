//
//  ViewController.swift
//  BezierPathAnimation
//
//  Created by Aleš Kocur on 09/10/15.
//  Copyright © 2015 The Funtasty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    
    let shapeLayer = CAShapeLayer()
    var panGestureRecognizer: UIPanGestureRecognizer!
    let animationDuration = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        shapeLayer.path = createPathForFrame(self.contentView.bounds, percent:0.0)
        shapeLayer.fillColor = UIColor.redColor().CGColor
        
        shapeLayer.speed = 0.0
        
        self.contentView.layer.addSublayer(shapeLayer)
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
        self.contentView.addGestureRecognizer(self.panGestureRecognizer)
    }

    func createPathForFrame(frame: CGRect, percent: CGFloat) -> CGPathRef {
        let zero_percent_width = CGRectGetWidth(frame) * 0.15
        let w = zero_percent_width + (CGRectGetWidth(frame) - zero_percent_width) * percent
        let h = CGRectGetHeight(frame)
        let h_1_4 = h / 4
        let h_half = h / 2
        
        let arc_angle_x: CGFloat = 0.2 - (0.1 * percent)
        let arc_angle_y: CGFloat = 0.6 + (0.1 * percent)
        
        let arc_middle: CGFloat = 0.1 + (0.1 * percent)
        
        // Create points
        let bottom_left_point = CGPointMake(0, h)
        let bottom_arc_point = CGPointMake(w / 2, h_1_4 * 3)
        let middle_right_point = CGPointMake(w, h_half)
        let top_arc_point = CGPointMake(w / 2, h_1_4)
        let top_left_point = CGPointMake(0, 0)
        
        // Create control points for points
        let bottom_arc_point_cp_1 = bottom_left_point
        // 1/5 of width and 4/6 of height from bottom arc to frame bottom
        let bottom_arc_point_cp_2 = CGPointMake(w * arc_angle_x, bottom_arc_point.y + ((h - bottom_arc_point.y) * (1.0 - arc_angle_y)))

        let middle_right_point_cp_1 = bottom_arc_point_cp_2.oppositeWithCenter(bottom_arc_point)
        let middle_right_point_cp_2 = CGPointMake(w, h_half + (h * arc_middle))
        
        // 1/5 of width and 4/6 of height from top to top arc y
        let top_left_point_cp_1 = CGPointMake(w * arc_angle_x, top_arc_point.y * arc_angle_y)
        let top_left_point_cp_2 = top_left_point
        
        let top_arc_point_cp_1 = CGPointMake(w, h_half - (h * arc_middle))
        let top_arc_point_cp_2 = top_left_point_cp_1.oppositeWithCenter(top_arc_point)
        
        // Compose bezier path
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, 0))
        bezierPath.addLineToPoint(bottom_left_point)
        bezierPath.addCurveToPoint(bottom_arc_point, controlPoint1: bottom_arc_point_cp_1, controlPoint2: bottom_arc_point_cp_2)
        bezierPath.addCurveToPoint(middle_right_point, controlPoint1: middle_right_point_cp_1, controlPoint2: middle_right_point_cp_2)
        bezierPath.addCurveToPoint(top_arc_point, controlPoint1: top_arc_point_cp_1, controlPoint2: top_arc_point_cp_2)
        bezierPath.addCurveToPoint(top_left_point, controlPoint1: top_left_point_cp_1, controlPoint2: top_left_point_cp_2)
        bezierPath.lineJoinStyle = .Round;
        
        return bezierPath.CGPath
    }

    func animationForShapeLayer() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = animationDuration
        
        animation.toValue = createPathForFrame(self.contentView.bounds, percent: 1.0)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        return animation
    }
    
    func didPan(recognizer: UIPanGestureRecognizer) {
        
        let location = recognizer.locationInView(self.contentView)
        let w = CGRectGetWidth(self.contentView.frame)
        let proportionalPositionInView = Double(location.x / (w * 0.9))
        print(proportionalPositionInView)
        let offset = CFTimeInterval(min(proportionalPositionInView * animationDuration, animationDuration))
        
        if (recognizer.state == UIGestureRecognizerState.Began) {
            self.shapeLayer.removeAllAnimations()
            self.shapeLayer.addAnimation(animationForShapeLayer(), forKey: "panAnimation")
            self.shapeLayer.timeOffset = offset

        } else if (recognizer.state == UIGestureRecognizerState.Changed) {
            
            self.shapeLayer.timeOffset = offset

        } else if (recognizer.state == UIGestureRecognizerState.Ended) {
            
            self.shapeLayer.removeAnimationForKey("panAnimation")
            self.shapeLayer.timeOffset = 0.0
        }
        
    }

}

