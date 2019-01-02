//
//  CharacterListViewCell.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 27/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import UIKit

class CharacterListViewCell: UITableViewCell {
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellSubtitle: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    func setupWith(char: Character) {
        self.cellTitle.text = char.name
        self.cellSubtitle.text = char.description
        //TODO: cell image
    }
}
