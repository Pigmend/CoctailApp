//
//  FilterCell.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell  {
    
    static func cellHeight() -> CGFloat { return 44.0 }
    
    // MARK: - Outlets -
    @IBOutlet weak private var filterNameLabel: UILabel!
    
    // MARK: - Interface -
    func fillCell(by name: String) {
        filterNameLabel.text = name
    }
}
