//
//  GradientCircleLayer.sừit
//  GradientCircleView
//
//  Created by Hung Thai Minh on 11/27/18.
//  Copyright © 2018 Hung Thai Minh. All rights reserved.
//

import UIKit

final class GradientCircleLayer: BasicProgressLayer {
    
    // Properties
    private let startPoints: [CGPoint] = {
        return [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 0),CGPoint(x: 1, y: 1),CGPoint(x: 0, y: 1)]
    }()
    
    private let endPoints: [CGPoint] = {
        return [CGPoint(x: 1, y: 1),CGPoint(x: 0, y: 1),CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 0)]
    }()
    
    private lazy var positionArrayWithMainBounds: [CGPoint] = {
        let first = CGPoint(x: (bounds.width/4)*3, y: (bounds.height/4)*1)
        let second = CGPoint(x: (bounds.width/4)*3, y: (bounds.height/4)*3)
        let third = CGPoint(x: (bounds.width/4)*1, y: (bounds.height/4)*3)
        let fourth = CGPoint(x: (bounds.width/4)*1, y: (bounds.height/4)*1)
        
        return [first,second,third,fourth]
    }()
    
    override init(at parentView: JLoadingView) {
        super.init(at: parentView)
        renderLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.duration = 2
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        rotateAnimation.toValue = Double.pi*2
        rotateAnimation.fromValue = 0
        
        add(rotateAnimation, forKey: "rotate")
    }
    
    override func stopAnimation() {
        removeAnimation(forKey: "rotate")
    }
    
    func graintFromColor(fromColor: UIColor, toColor: UIColor, count: Int) -> [UIColor] {
        var fromR: CGFloat = 0.0, fromG: CGFloat = 0.0, fromB: CGFloat = 0.0, fromAlpha: CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR: CGFloat = 0.0, toG: CGFloat = 0.0, toB: CGFloat = 0.0, toAlpha: CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        var result = [UIColor]()
        for i in 0...count {
            let oneR = fromR + (toR - fromR)/CGFloat(count) * CGFloat(i)
            let oneG = fromG + (toG - fromG)/CGFloat(count) * CGFloat(i)
            let oneB = fromB + (toB - fromB)/CGFloat(count) * CGFloat(i)
            let oneAlpha = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(i)
         
            result.append(UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha))
        }
        return result
    }
    
    func midColorWithFromColor(fromColor:UIColor, toColor:UIColor, progress:CGFloat) -> UIColor {
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        let oneR = fromR + (toR - fromR) * progress
        let oneG = fromG + (toG - fromG) * progress
        let oneB = fromB + (toB - fromB) * progress
        let oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress
        let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
        return oneColor
    }
}

// MARK: - Private methods -
private extension GradientCircleLayer {
    func renderLayer() {
        guard let parentView = parentView else { return }
        
        bounds = CGRect(x: 0, y: 0, width: parentView.bounds.width*scaleRatio, height: parentView.bounds.height*scaleRatio)
        position = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        
        let colors = graintFromColor(fromColor: parentView.strokeColor.withAlphaComponent(0.1), toColor: parentView.strokeColor, count: 4)
        for i in 0..<colors.count-1 {
            let graint = CAGradientLayer()
            graint.bounds = CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height/2)
            let valuePoint = positionArrayWithMainBounds[i]
            graint.position = valuePoint
            let fromColor = colors[i]
            let toColor = colors[i+1]
            
            graint.colors = [fromColor, toColor].map{$0.cgColor}
            graint.locations = [0.0, 1.0].map{NSNumber(value: $0)}
            graint.startPoint = startPoints[i]
            graint.endPoint = endPoints[i]
            addSublayer(graint)
            
            //Set mask
            let shapelayer = CAShapeLayer()
            let rect = CGRect(x: 0, y: 0, width: bounds.width - 2 * strokeWidth, height: bounds.height - 2 * strokeWidth)
            shapelayer.bounds = rect
            shapelayer.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
            shapelayer.strokeColor = toColor.cgColor
            shapelayer.fillColor = UIColor.clear.cgColor
            shapelayer.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).cgPath
            shapelayer.lineWidth = strokeWidth
            shapelayer.lineCap = .round
            shapelayer.strokeStart = 0.015
            shapelayer.strokeEnd = 0.985
            mask = shapelayer
        }
    }
}


// MARK: - Animation methods -
extension GradientCircleLayer {
    
    // This is what you call if you want to draw a full circle.
    func animateCircle(duration: TimeInterval) {
        animateCircleTo(duration: duration, fromValue: 0.010, toValue: 0.99)
    }
    
    // This is what you call to draw a partial circle.
    func animateCircleTo(duration: TimeInterval, fromValue: CGFloat, toValue: CGFloat){
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.isRemovedOnCompletion = true
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0.010 (no circle) to 0.99 (full circle)
        animation.fromValue = 0.010
        animation.toValue = toValue
        
        // Do an easeout. Don't know how to do a spring instead
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        // Set the circleLayer's strokeEnd property to 0.99 now so that it's the
        // right value when the animation ends.
        let circleMask = self.mask as! CAShapeLayer
        circleMask.strokeEnd = toValue
        
        // Do the actual animation
        circleMask.removeAllAnimations()
        circleMask.add(animation, forKey: "animateCircle")
    }
    
}
