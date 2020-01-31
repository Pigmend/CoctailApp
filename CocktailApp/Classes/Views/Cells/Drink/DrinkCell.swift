//
//  DrinkCell.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import UIKit
import SDWebImage

class DrinkCell: UITableViewCell {
    
    static func cellHeight() -> CGFloat { return 88.0 }
    
    // MARK: - Outlets -
    @IBOutlet weak private var drinkImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(by name: String, _ urlString: String) {
        nameLabel.text = name
        drinkImage.sd_setImage(with: URL(string: urlString), 
                            placeholderImage: UIImage(named: "placeholder"))
    }
}
