//
//  LoadingOverlay.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 21/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import UIKit

class LoadingOverlay: UIView {
    static let loadingOverLayRadius: CGFloat = CGFloat(50.0)
    
    var strokeThickness: CGFloat = 3.0
    var radius: CGFloat = LoadingOverlay.loadingOverLayRadius
    var strokeColor: UIColor = UIColor("#e60a14")
    var defaultBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    var givenBackgroundColor: UIColor?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupDefaults()
    }
    
    init(frame: CGRect, radius: CGFloat, backgroundColor: UIColor) {
        super.init(frame: frame)
        self.radius = radius
        self.givenBackgroundColor = backgroundColor
        self.setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupDefaults()
    }
    
    func setupDefaults() {
        self.alpha = 0.0
        if self.radius == LoadingOverlay.loadingOverLayRadius {
            self.radius = self.getDefaultRadius()
        }
        self.backgroundColor = self.givenBackgroundColor != nil ? self.givenBackgroundColor : defaultBackgroundColor
        self.clipsToBounds = true
        
        let arcCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: self.radius, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2+Double.pi*5), clockwise: true)
        
        self.indefiniteAnimatedLayer = CAShapeLayer()
        self.indefiniteAnimatedLayer.contentsScale = UIScreen.main.scale
        self.indefiniteAnimatedLayer.frame = self.bounds
        self.indefiniteAnimatedLayer.fillColor = UIColor.clear.cgColor
        self.indefiniteAnimatedLayer.strokeColor = self.strokeColor.cgColor
        self.indefiniteAnimatedLayer.lineWidth = self.strokeThickness
        self.indefiniteAnimatedLayer.lineCap = CAShapeLayerLineCap.round
        self.indefiniteAnimatedLayer.lineJoin = CAShapeLayerLineJoin.bevel
        self.indefiniteAnimatedLayer.path = smoothedPath.cgPath
        
        let maskLayer = CALayer()
        maskLayer.contents = UIImage(named: "angle_mask")?.cgImage
        maskLayer.frame = self.indefiniteAnimatedLayer.bounds
        self.indefiniteAnimatedLayer.mask = maskLayer
        
        let animationDuration: TimeInterval = 1
        let linearCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = NSNumber(value: Double.pi*2)
        animation.duration = animationDuration
        animation.timingFunction = linearCurve
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.autoreverses = false
        self.indefiniteAnimatedLayer.mask?.add(animation, forKey: "rotate")
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = Float.greatestFiniteMagnitude
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction = linearCurve
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0.015
        strokeStartAnimation.toValue = 0.515
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.485
        strokeEndAnimation.toValue = 0.985
        
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        self.indefiniteAnimatedLayer.add(animationGroup, forKey: "progress")
    }
    
    func getDefaultRadius() -> CGFloat {
        return min(LoadingOverlay.loadingOverLayRadius, min(self.frame.size.width,self.frame.size.height) / 4)
    }
    
    var indefiniteAnimatedLayer: CAShapeLayer!
    
    func layoutAnimatedLayer() {
        let layer = self.indefiniteAnimatedLayer
        
        self.layer.addSublayer(layer!)
        layer?.position = CGPoint(x: self.bounds.width - ((layer?.bounds.width)!/2), y: self.bounds.height - (layer?.bounds.height)! / 2)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            self.layoutAnimatedLayer()
        }
        else {
            self.indefiniteAnimatedLayer.removeFromSuperlayer()
            self.indefiniteAnimatedLayer = nil
        }
    }
}

