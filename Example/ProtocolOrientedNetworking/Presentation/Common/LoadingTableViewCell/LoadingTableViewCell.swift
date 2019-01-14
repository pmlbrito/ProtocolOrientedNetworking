//
//  LoadingTableViewCell.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 14/01/2019.
//  Copyright © 2019 pmlbrito. All rights reserved.
//

import UIKit

open class LoadingTableViewCell: UITableViewCell {
    //UI
    @IBOutlet weak var loaderView: SpinnerView!
    
    func setupView() {
        // View
        self.backgroundColor = UIColor.clear
        
        //Loading Spinner
        self.loaderView.backgroundColor = UIColor.clear
        self.loaderView.spinnerBackgroundColor = UIColor.clear
        self.loaderView.spinnerStrokeColor = UIColor("#e60a14")
        self.loaderView.showSpinner()
    }
}
