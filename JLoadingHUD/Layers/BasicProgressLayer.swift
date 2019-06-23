//
//  BasicProgressLayer.swift
//  JLoadingView
//
//  Created by Hung Thai Minh on 2/24/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import UIKit

public struct LayerName {
    static let circleSpin = "Circle Spin Layer"
}

public enum ProgressLayerType {
    case gradientCircle
    case circleSpin
    case circleSemi
    case circleScaleRipple
    case ballPulse
    case ballPulseQueue
    case ballPulseRipple
    case ballPulseOpacityRipple
    case ballPulseSync
}

public class BasicProgressLayer: CALayer {

    // Properties
    var strokeColor: UIColor = .white
    var strokeWidth: CGFloat = 4
    var scaleRatio: CGFloat = 2/3
    var parentView: JLoadingView?
    
    init(at parentView: JLoadingView) {
        self.parentView = parentView
        parentView.layer.sublayers?.removeAll()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {}
    func stopAnimation() {}
}
