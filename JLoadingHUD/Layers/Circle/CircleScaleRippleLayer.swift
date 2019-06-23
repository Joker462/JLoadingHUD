//
//  CircleScaleRippleLayer.swift
//  JLoadingHUD
//
//  Created by MMI001 on 4/10/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import UIKit

final class CircleScaleRippleLayer: BasicProgressLayer {
    
    private var progressLayer: CAShapeLayer?
    private let DURATION = 0.5
    
    private lazy var animations: CAAnimationGroup = {
        let scaleOutAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleOutAnimation.duration = DURATION
        scaleOutAnimation.fromValue = 1
        scaleOutAnimation.toValue = 4
        scaleOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleOutAnimation.fillMode = .forwards
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.beginTime = DURATION
        opacityAnimation.duration = DURATION/2
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacityAnimation.fillMode = .forwards
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleOutAnimation, opacityAnimation]
        animationGroup.duration = DURATION + DURATION/2
        animationGroup.repeatCount = .greatestFiniteMagnitude
        return animationGroup
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
       progressLayer?.add(animations, forKey: "strokeAnimation")
    }
    
    override func stopAnimation() {
        progressLayer?.removeAnimation(forKey: "strokeAnimation")
    }
}

// MARK: - Private methods -
private extension CircleScaleRippleLayer {
    func renderLayer() {
        guard let parentView = parentView else { return }
        let position = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        let strokeWidth = self.strokeWidth/3
        let radius = ((parentView.bounds.width*scaleRatio)/2 - strokeWidth/2)/4
        let bezierPath = UIBezierPath(arcCenter: .zero,
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: .pi*2,
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
