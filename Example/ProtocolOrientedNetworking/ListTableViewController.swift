//
//  ListTableViewController.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Foundation


class ListTableViewController: UIViewController {
    
    @IBOutlet weak var heroList: UITableView!
    
    let charactersClient = CharactersAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let's do some concept testing
        
        self.requestCharactersPage()
    }
}

//Data loading extension - this is just an example, so no need to over-engeneering
extension ListTableViewController {
    func requestCharactersPage() {
        charactersClient.getCharactersList(size: 30, offset: 0) { result in
            switch result {
            case .success(let response):
                //yay we got some nice results
                NSLog(String(describing: response))
                break
            case .failure(let error):
                NSLog("Error: \(error)")
            }
        }
    }
}
