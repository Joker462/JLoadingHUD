//
//  BallPulseSyncLayer.swift
//  JLoadingHUD
//
//  Created by MMI001 on 4/5/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import UIKit

final class BallPulseSyncLayer: BasicProgressLayer {
    
    // Properties
    private let firstBall = CAShapeLayer()
    private let middleBall = CAShapeLayer()
    private let lastBall = CAShapeLayer()
    
    private let DURATION = 0.2
    
    private lazy var firstBallAnimations: CAAnimationGroup = {
        let scaleIn = scaleInAnimation()
        scaleIn.beginTime = 1.0
        
        let firstBallAnimations = CAAnimationGroup()
        firstBallAnimations.duration = 1.2
        firstBallAnimations.animations = [scaleOutAnimation(), scaleIn]
        
        return firstBallAnimations
    }()
    
    private lazy var middleBallAnimations: CAAnimationGroup = {
        let scaleOut = scaleOutAnimation()
        scaleOut.beginTime = 0.2
        let scaleIn = scaleInAnimation()
        scaleIn.beginTime = 0.8
        
        let middleBallAnimations = CAAnimationGroup()
        middleBallAnimations.duration = 1.0
        middleBallAnimations.animations = [scaleOut, scaleIn]
        
        return middleBallAnimations
    }()
    
    private lazy var lastBallAnimations: CAAnimationGroup = {
        let scaleOut = scaleOutAnimation()
        scaleOut.beginTime = 0.4
        let scaleIn = scaleInAnimation()
        scaleIn.beginTime = 0.6
        
        let lastBallAnimations = CAAnimationGroup()
        lastBallAnimations.duration = 1.0
        lastBallAnimations.animations = [scaleOut, scaleIn]
        
        return lastBallAnimations
    }()
    
    override init(at parentView: JLoadingView) {
        super.init(at: parentView)
        renderLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        firstBall.add(firstBallAnimations, forKey: "firstBallScaleAnimations")
        middleBall.add(middleBallAnimations, forKey: "middleBallScaleAnimations")
        
        let lastBallAnimation = lastBallAnimations
        lastBallAnimation.delegate = self
        lastBall.add(lastBallAnimation, forKey: "lastBallScaleAnimations")
    }
    
    override func stopAnimation() {
        firstBall.removeAnimation(forKey: "firstBallScaleAnimations")
        middleBall.removeAnimation(forKey: "middleBallScaleAnimations")
        lastBall.removeAnimation(forKey: "lastBallScaleAnimations")
    }
}

// MARK: - Private methods -
private extension BallPulseSyncLayer  {
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
        
        middleBall.path = bezierPath.cgPath
        middleBall.frame = ballFrame
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
    
    func scaleOutAnimation() -> CABasicAnimation {
        let scaleOutAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleOutAnimation.fromValue = 1
        scaleOutAnimation.toValue = 1.5
        scaleOutAnimation.duration = DURATION
        scaleOutAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleOutAnimation.fillMode = .forwards
        return scaleOutAnimation
    }
    
    func scaleInAnimation() -> CABasicAnimation {
        let scaleInAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleInAnimation.fromValue = 1.5
        scaleInAnimation.toValue = 1
        scaleInAnimation.duration = DURATION
        scaleInAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        scaleInAnimation.fillMode = .forwards
        return scaleInAnimation
    }
}

extension BallPulseSyncLayer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + DURATION) { [weak self] in
            self?.stopAnimation()
            self?.startAnimation()
        }
    }
}
