//
//  ListTableViewController.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import UIKit
import Foundation


class ListTableViewController: BaseViewController {
    
    @IBOutlet weak var heroList: UITableView!
    
    // API
    let charactersClient = CharactersAPIClient()
    // Data
    var charactersItems = [Character]()
    var pageIndex: Int = 0
    let pageSize: Int = 30
    var hasMoreItems: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heroList.dataSource = self
        self.heroList.delegate = self
        
        //let's do some concept testing
        self.showLoadingIndicator()
        self.requestCharactersPage()
    }
}

extension ListTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.charactersItems.count > 0 {
            return self.hasMoreItems ? self.charactersItems.count + 1 : self.charactersItems.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.hasMoreItems && indexPath.item >= self.charactersItems.count {
            let loader = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as? LoadingTableViewCell
            loader?.setupView()
            return loader ?? UITableViewCell()
        }
        
        let char = self.charactersItems[indexPath.row]
        let cell = self.heroList.dequeueReusableCell(withIdentifier: "image_title_label_table_view_cell", for: indexPath) as? CharacterListViewCell
        
        if cell != nil {
            cell?.setupWith(char: char)
            if let charImageURL = char.thumbnail?.getImageURL(type: .thumbnail_small) {
                charactersClient.getCharacterImageFor(imageURL: charImageURL, imageView: cell?.cellImage)
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is LoadingTableViewCell {
            self.requestCharactersPage()
        }
    }
}

//Data loading extension - this is just an example, so no need to over-engeneering
extension ListTableViewController {
    func requestCharactersPage() {
        if hasMoreItems {
            let requestOffset = (pageIndex * pageSize) - 1 > 0 ? (pageIndex * pageSize) - 1 : 0
            charactersClient.getCharactersList(size: pageSize, offset: requestOffset) { [weak self] result in
                self?.hideLoadingIndicator()
                switch result {
                case .success(let response):
                    //yay we got some nice results
                    NSLog(String(describing: response))
                    
                    self?.charactersItems.append(contentsOf: response?.data?.results ?? [])
                    
                    if response?.data?.results?.count == self?.pageSize {
                        self?.pageIndex += 1
                        self?.heroList.reloadData()
                    } else {
                        self?.hasMoreItems = false
                    }
                    break
                case .failure(let error):
                    NSLog("Error: \(error)")
                }
            }
        }
    }
}
