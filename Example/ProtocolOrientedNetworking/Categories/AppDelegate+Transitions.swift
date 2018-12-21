//
//  AppDelegate+Transitions.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 21/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import UIKit

extension AppDelegate {
    func changeRootViewController(viewController: UIViewController) {
        let snapshot: UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
        viewController.view.addSubview(snapshot)
        
        self.window?.rootViewController = viewController
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: { (_: Bool) in
            snapshot.removeFromSuperview()
        })
    }
}
