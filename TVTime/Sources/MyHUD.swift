//
//  MyHUD.swift
//  TVTime
//
//  Created by McCarroll, George (US - Seattle) on 1/31/17.
//
//

import UIKit
import IBAnimatable

final class MyHUD: NSObject {
    
    static let sharedHUD = MyHUD()
    
    fileprivate let container = ContainerView()
    
    
    override init() {
        super.init()
        
        container.frameView.autoresizingMask = [ .flexibleLeftMargin,
                                                 .flexibleRightMargin,
                                                 .flexibleTopMargin,
                                                 .flexibleBottomMargin ]
    }
    
    func show() {
        
        let view = UIApplication.shared.keyWindow!
        
        if  !view.subviews.contains(container) {
            view.addSubview(container)
            container.frame.origin = CGPoint.zero
            container.frame.size = view.frame.size
            container.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            container.isHidden = true
            container.frameView.frame = container.frame
        }
        
        showContent()
    }
    
    func hide() {
        container.hideFrameView()
    }
    
    func showContent() {
        container.showFrameView()
    }
}

final class ContainerView: UIView {
    
    let frameView: AnimatableActivityIndicatorView
    
    fileprivate var willHide = false
    fileprivate let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0.0, alpha:0.25)
        view.alpha = 0.0
        return view
    }()
    
    internal init(frameView: AnimatableActivityIndicatorView = AnimatableActivityIndicatorView()) {
        
        frameView.animationType = .ballScaleMultiple
        frameView.color = UIColor.lightGray
        
        self.frameView = frameView
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        frameView = AnimatableActivityIndicatorView()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
        
        addSubview(backgroundView)
        addSubview(frameView)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        frameView.center = center
        backgroundView.frame = bounds
    }
    
    func showFrameView() {
        layer.removeAllAnimations()
        frameView.center = center
        frameView.alpha = 1.0
        isHidden = false
        frameView.startAnimating()
        
    }
    
    func hideFrameView() {
        frameView.alpha = 0.0
        isHidden = true
        frameView.stopAnimating()
    }
}

