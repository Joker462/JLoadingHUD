//
//  CircleSpinLayer.swift
//  JLoadingView
//

import UIKit

final class CircleSpinLayer: BasicProgressLayer {
    
    // Animations
    private let startTime: Double = 0.5
    private let strokeDuration: Double = 2.0

    private lazy var strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = strokeDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = strokeDuration + startTime
        group.repeatCount = .infinity
        group.animations = [animation]
        
        return group
    }()
    
    private lazy var strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = startTime
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = strokeDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = strokeDuration + startTime
        group.repeatCount = .infinity
        group.animations = [animation]
        
        return group
    }()
    
    private lazy var rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 4
        animation.fromValue = 0
        animation.toValue = Float.pi*2
        animation.repeatCount = .infinity
        
        return animation
    }()
    
    private var progressLayer: CAShapeLayer?
    
    // Override
    override init(at parentView: JLoadingView) {
        super.init(at: parentView)
        renderLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        progressLayer?.add(strokeEndAnimation, forKey: "strokeEndAnimation")
        progressLayer?.add(strokeStartAnimation, forKey: "strokeStartAnimation")
        progressLayer?.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    override func stopAnimation() {
        progressLayer?.removeAnimation(forKey: "strokeEndAnimation")
        progressLayer?.removeAnimation(forKey: "strokeStartAnimation")
        progressLayer?.removeAnimation(forKey: "rotationAnimation")
    }
}

// MARK: - Private methods -
private extension CircleSpinLayer {
    func renderLayer() {
        guard let parentView = parentView else { return }
        let position = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        let radius = (parentView.bounds.width*scaleRatio)/2 - strokeWidth/2
        let bezierPath = UIBezierPath(arcCenter: .zero,
                                      radius: radius,
                                      startAngle: -(.pi/2),
                                      endAngle: .pi + .pi/2,
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
