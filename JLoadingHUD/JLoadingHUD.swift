//
//  JLoadingHUD.swift
//  JLoadingHUD
//
//  Created by Hung Thai Minh on 3/14/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import UIKit

public class JLoadingHUD {
    public static let shared = JLoadingHUD()
    private let DURATION = 0.5
    
    private init() {
        initBackgroundView()
        initLoadingView()
    }
    
    // Properties
    internal let backgroundView = UIView()
    internal var loadingView: JLoadingView?
    
    // Settings
    // BackgroundView
    public var backgroundViewColor: UIColor = .clear {
        didSet {
            backgroundView.backgroundColor = backgroundViewColor
        }
    }
    
    // LoadingView
    public var loadingViewSize: CGFloat = 128.0
    public var loadingViewBackgroundColor: UIColor = .red {
        didSet {
            loadingView?.backgroundColor = loadingViewBackgroundColor
        }
    }
    
    public var loadingViewCornerRadius: CGFloat = 16 {
        didSet {
            loadingView?.layer.cornerRadius = loadingViewCornerRadius
        }
    }
    
    public var loadingStrokeWidth: CGFloat = 4 {
        didSet {
            loadingView?.strokeWidth = loadingStrokeWidth
        }
    }
    
    public var loadingStrokeColor: UIColor = .white {
        didSet {
            loadingView?.strokeColor = loadingStrokeColor
        }
    }
    
    // ProgressLayerType
    public var progressLayerType: ProgressLayerType = .circleSpin {
        didSet {
            loadingView?.progressLayerType = progressLayerType
        }
    }
    
    open func show(progressLayerType: ProgressLayerType = .circleSpin, completion: (() -> Void)? = nil) {
        guard let parentView = getRootView() else { return }
        if Thread.isMainThread {
            self.progressLayerType = progressLayerType
            loadingView?.alpha = 0
            parentView.addSubview(backgroundView)
            UIView.animate(withDuration: DURATION, animations: { [weak self] in
                self?.loadingView?.alpha = 1
            }) { (_) in
                completion?()
            }
        }
    }
    
    open func show(after duration: TimeInterval, progressLayerType: ProgressLayerType = .circleSpin, completion: (() -> Void)? = nil) {
        runCode { [weak self] in
            guard let `self` = self,
                let parentView = self.getRootView() else { return }
            self.progressLayerType = progressLayerType
            self.loadingView?.alpha = 0
            parentView.addSubview(self.backgroundView)
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.loadingView?.alpha = 1
            }) { (_) in
                completion?()
            }
        }
    }
}

// MARK: - Actions -
extension JLoadingHUD {
    
    
    public func hide(completion: (() -> Void)? = nil) {
        runCode { [weak self] in
            guard let `self` = self else { return }
            UIView.animate(withDuration: self.DURATION,
                           animations: { [weak self] in
                            self?.backgroundView.alpha = 0
            }) { [weak self] (_) in
                self?.loadingView?.removeFromSuperview()
                self?.backgroundView.removeFromSuperview()
                completion?()
            }
        }
    }
    
    public func hide(duration: TimeInterval, completion: (() -> Void)? = nil) {
        runCode { [weak self] in
            guard let _ = self else { return }
            UIView.animate(withDuration: duration,
                           animations: { [weak self] in
                            self?.backgroundView.alpha = 0
            }) { [weak self] (_) in
                self?.loadingView?.removeFromSuperview()
                self?.backgroundView.removeFromSuperview()
                completion?()
            }
        }
    }
}

// MARK: - Private methods -
private extension JLoadingHUD {
    
    func initBackgroundView() {
        backgroundView.backgroundColor = backgroundViewColor
        backgroundView.frame = UIScreen.main.bounds
    }
    
    func initLoadingView() {
        loadingView?.removeFromSuperview()
        loadingView = JLoadingView(frame: CGRect(x: 0, y: 0, width: loadingViewSize, height: loadingViewSize))
        loadingView?.clipsToBounds = true
        loadingView?.center = backgroundView.center
        loadingView?.backgroundColor = loadingViewBackgroundColor
        loadingView?.layer.cornerRadius = loadingViewCornerRadius
        backgroundView.addSubview(loadingView!)
        
        loadingView?.strokeColor = loadingStrokeColor
        loadingView?.strokeWidth = loadingStrokeWidth
    }
    
    func getRootView() -> UIView? {
        if let window = UIApplication.shared.keyWindow {
            return window
        } else {
            guard let window = UIApplication.shared.windows.last else { return nil }
            return window.rootViewController?.view
        }
    }
    
    func runCode(completion: @escaping ()->()) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
