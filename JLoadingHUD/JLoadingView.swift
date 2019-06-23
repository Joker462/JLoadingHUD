//
//  JLoadingView.swift
//  JLoadingView
//
//  Created by Hung Thai Minh on 11/26/18.
//  Copyright © 2018 Hung Thai Minh. All rights reserved.
//

import UIKit

public class JLoadingView: UIView {
    
    // Properties
    public var strokeWidth: CGFloat = 4 {
        didSet {
            loadingLayer?.strokeWidth = strokeWidth
        }
    }
    
    var strokeColor: UIColor = .white {
        didSet {
            loadingLayer?.strokeColor = strokeColor
        }
    }
    
    private var loadingLayer: BasicProgressLayer?
    
    var progressLayerType: ProgressLayerType = .circleSpin {
        didSet {
            setupUI()
        }
    }
    
    // Constructions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Private methods -
private extension JLoadingView {
    func setupUI() {
        
        switch progressLayerType {
        case .circleSpin:
            loadingLayer = CircleSpinLayer(at: self)
        case .circleSemi:
            loadingLayer = CircleSemiLayer(at: self)
        case .circleScaleRipple:
            loadingLayer = CircleScaleRippleLayer(at: self)
        case .gradientCircle:
            loadingLayer = GradientCircleLayer(at: self)
        case .ballPulse:
            loadingLayer = BallPulseLayer(at: self)
        case .ballPulseQueue:
            loadingLayer = BallPulseQueueLayer(at: self)
        case .ballPulseRipple:
            loadingLayer = BallPulseRippleLayer(at: self)
        case .ballPulseOpacityRipple:
            loadingLayer = BallPulseOpacityRippleLayer(at: self)
        case .ballPulseSync:
            loadingLayer = BallPulseSyncLayer(at: self)
        }
        
        layer.addSublayer(loadingLayer!)
        loadingLayer?.startAnimation()
    }
}
