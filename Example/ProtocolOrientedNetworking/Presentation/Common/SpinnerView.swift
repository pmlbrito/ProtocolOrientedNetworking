//
//  SpinnerView.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 14/01/2019.
//  Copyright © 2019 pmlbrito. All rights reserved.
//

import UIKit

class SpinnerView: UIView {
    
    var spinnerStrokeColor: UIColor = UIColor("#e60a14")
    var spinnerBackgroundColor: UIColor = UIColor.clear
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showSpinner() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let spinner = LoadingOverlay(frame: self.bounds)
        spinner.strokeColor = UIColor("#e60a14")
        spinner.defaultBackgroundColor = self.spinnerBackgroundColor
        self.addSubview(spinner)
        spinner.alpha = 0.0
        spinner.setupDefaults()
        spinner.layoutAnimatedLayer()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { [weak spinner] in
            spinner?.alpha = 1.0
            }, completion: nil)
    }
}
