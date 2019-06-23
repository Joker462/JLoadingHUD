//
//  CircleSemiLayer.swift
//  JLoadingHUD
//
//  Created by MMI001 on 3/25/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import UIKit

final class CircleSemiLayer: BasicProgressLayer {
    
    private var progressLayer: CAShapeLayer?
    
    private lazy var rotateAnimation: CAAnimation = {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.duration = 0.6
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        rotateAnimation.toValue = Double.pi*2
        rotateAnimation.fromValue = 0
        
        return rotateAnimation
    }()
    
    private lazy var scaleAnimation: CAAnimation = {
        let scaleInAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleInAnimation.duration = 0.3
        scaleInAnimation.repeatCount = .greatestFiniteMagnitude
        scaleInAnimation.fromValue = 1
        scaleInAnimation.toValue = 0.8
        scaleInAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let scaleOutAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleOutAnimation.beginTime = 0.3
        scaleOutAnimation.duration = 0.3
        scaleOutAnimation.fromValue = 0.8
        scaleOutAnimation.toValue = 1
        scaleOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let scaleAnimationGroup = CAAnimationGroup()
        scaleAnimationGroup.animations = [scaleInAnimation, scaleOutAnimation]
        scaleAnimationGroup.duration = 0.6
        scaleAnimationGroup.repeatCount = .greatestFiniteMagnitude
        
        return scaleAnimationGroup
    }()
    
    // Override
    override init(at parentView: JLoadingView) {
        super.init(at: parentView)
        renderLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotateAnimation, scaleAnimation]
        groupAnimation.duration = 0.6
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        
        progressLayer?.add(groupAnimation, forKey: "strokeAnimation")
    }
    
    override func stopAnimation() {
        progressLayer?.removeAnimation(forKey: "strokeAnimation")
    }
}

// MARK: - Private methods -
private extension CircleSemiLayer {
    func renderLayer() {
        guard let parentView = parentView else { return }
        let position = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        let radius = (parentView.bounds.width*scaleRatio)/2 - strokeWidth/2
        let bezierPath = UIBezierPath(arcCenter: .zero,
                                      radius: radius,
                                      startAngle: -.pi/6,
                                      endAngle: (-5 * .pi/6),
                                      clockwise: true)
        bezierPath.lineWidth = strokeWidth
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        bezierPath.stroke()
        
        progressLayer = CAShapeLayer()
        progressLayer?.position = position
        progressLayer?.lineWidth = strokeWidth
        progressLayer?.strokeColor = strokeColor.cgColor
        progressLayer?.path = bezierPath.cgPath
        progressLayer?.fillColor = nil
        
        addSublayer(progressLayer!)
    }
}
