//
//  BallPulseRippleLayer.swift
//  JLoadingHUD
//
//  Created by MMI001 on 4/4/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import UIKit

final class BallPulseRippleLayer: BasicProgressLayer {
    // Properties
    private let firstBall = CAShapeLayer()
    private let middleBall = CAShapeLayer()
    private let lastBall = CAShapeLayer()
    
    private let DURATION = 0.4
    
    private lazy var ballAnimation: CAAnimation = {
        let scaleInAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleInAnimation.duration = DURATION
        scaleInAnimation.fromValue = 1
        scaleInAnimation.toValue = 1/2
        scaleInAnimation.fillMode = .forwards
        scaleInAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let scaleOutAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleOutAnimation.beginTime = DURATION
        scaleOutAnimation.duration = DURATION
        scaleOutAnimation.fromValue = 1/2
        scaleOutAnimation.toValue = 1
        scaleOutAnimation.fillMode = .forwards
        scaleOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let scaleAnimationGroup = CAAnimationGroup()
        scaleAnimationGroup.animations = [scaleInAnimation, scaleOutAnimation]
        scaleAnimationGroup.duration = DURATION*2
        scaleAnimationGroup.repeatCount = .greatestFiniteMagnitude
        
        return scaleAnimationGroup
    }()
    
    private lazy var middleBallAnimation: CAAnimation = {
        let scaleOutAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleOutAnimation.duration = DURATION
        scaleOutAnimation.fromValue = 1
        scaleOutAnimation.toValue = 2
        scaleOutAnimation.fillMode = .forwards
        scaleOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let scaleInAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleInAnimation.beginTime = DURATION
        scaleInAnimation.duration = DURATION
        scaleInAnimation.fromValue = 2
        scaleInAnimation.toValue = 1
        scaleInAnimation.fillMode = .forwards
        scaleInAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let scaleAnimationGroup = CAAnimationGroup()
        scaleAnimationGroup.animations = [scaleOutAnimation, scaleInAnimation]
        scaleAnimationGroup.duration = DURATION*2
        scaleAnimationGroup.repeatCount = .greatestFiniteMagnitude
        
        return scaleAnimationGroup
    }()
    
    override init(at parentView: JLoadingView) {
        super.init(at: parentView)
        renderLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        firstBall.add(ballAnimation, forKey: "firstBallScaleAnimation")
        middleBall.add(middleBallAnimation, forKey: "middleBallScaleAnimation")
        lastBall.add(ballAnimation, forKey: "lastBallScaleAnimation")
    }
    
    override func stopAnimation() {
        firstBall.removeAnimation(forKey: "firstBallScaleAnimation")
        middleBall.removeAnimation(forKey: "middleBallScaleAnimation")
        lastBall.removeAnimation(forKey: "lastBallScaleAnimation")
    }
}

// MARK: - Private methods -
private extension BallPulseRippleLayer  {
    func renderLayer() {
        guard let parentView = parentView else { return }
        let contentWidth = parentView.frame.width*scaleRatio - 3
        let ballWidth = contentWidth/3
        let offsetX = (parentView.bounds.width - contentWidth)/2
        let offsetY = parentView.bounds.midY
        let ballFrame = CGRect(x: 0, y: 0, width: ballWidth/2, height: ballWidth/2)
        let bezierPath = UIBezierPath(roundedRect: ballFrame, cornerRadius: ballWidth/4)
        
        firstBall.path = bezierPath.cgPath
        firstBall.frame = ballFrame
        firstBall.position = CGPoint(x: offsetX+ballWidth/2, y: offsetY)
        firstBall.fillColor = strokeColor.cgColor
        
        let middleBallFrame = CGRect(x: 0, y: 0, width: ballWidth/4, height: ballWidth/4)
        middleBall.path = UIBezierPath(roundedRect: middleBallFrame, cornerRadius: ballWidth/8).cgPath
        middleBall.frame = middleBallFrame
        middleBall.position = CGPoint(x: parentView.bounds.midX, y: offsetY)
        middleBall.fillColor = strokeColor.cgColor
        
        lastBall.path = bezierPath.cgPath
        lastBall.frame = ballFrame
        lastBall.position = CGPoint(x: middleBall.position.x + ballWidth, y: offsetY)
        lastBall.fillColor = strokeColor.cgColor
        
        addSublayer(firstBall)
        addSublayer(middleBall)
        addSublayer(lastBall)
    }
}
