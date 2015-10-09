//
//  CGPoint+Vector.swift
//  BezierPathAnimation
//
//  Created by Aleš Kocur on 09/10/15.
//  Copyright © 2015 The Funtasty. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    var description: String {
        return "(\(x), \(y))"
    }
    
    func oppositeWithCenter(center: CGPoint) -> CGPoint {
        return (center - self) + center
    }
    
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

