//
//  BaseViewController.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 21/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import UIKit

enum ViewControllerPresentationType: String {
    case pushStack, modal, replaceNavigation, replaceAtRoot
}

class BaseViewController: UIViewController {
    var loadingView: LoadingOverlay?
    var parentView: UIView?
   
    // MARK: Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - BaseViewController Implementation
    var appDelegate: AppDelegate {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate
        }
        else { fatalError() }
    }
    
    // MARK: Loading Indicator
    public func showLoadingIndicator() {
        var parent: UIView? = UIApplication.shared.keyWindow
        if parent == nil {
            parent = self.view
        }
        
        var loading = self.loadingView
        if loading != nil {
            return
        }
        loading = LoadingOverlay(frame: parent!.bounds)
        parent!.addSubview(loading!)
        parent!.bringSubviewToFront(loading!)
        loading?.alpha = 0
        
        self.loadingView = loading
        
        weak var load = loading
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            load?.alpha = 1.0
        }, completion: { _ in
        })
    }
    
    public func hideLoadingIndicator() {
        weak var load = self.loadingView
        self.loadingView = nil
        load?.alpha = 1.0
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            load?.alpha = 0.0
        }, completion: { _ in
            load?.removeFromSuperview()
        })
    }
    
    // MARK: Base navigation actions
    func transtitionToNextViewController(fromViewController: UIViewController, destinationViewController: UIViewController?, transitionType: ViewControllerPresentationType?) {
        if transitionType != nil && destinationViewController != nil {
            switch transitionType! {
            case .pushStack:
                let navigationController = fromViewController.navigationController
                navigationController?.pushViewController(destinationViewController!, animated: true)
            case .modal:
                fromViewController.present(destinationViewController!, animated: true, completion: nil)
            case .replaceNavigation:
                let newNavigationController = UINavigationController(rootViewController: destinationViewController!)
                let appWindow = UIApplication.shared.delegate?.window!
                //animate swapping with nice transition
                UIView.transition(with: appWindow!, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                    appWindow!.rootViewController = newNavigationController
                }, completion: nil)
            case .replaceAtRoot:
                self.appDelegate.changeRootViewController(viewController: destinationViewController!)
            }
        }
    }
}
