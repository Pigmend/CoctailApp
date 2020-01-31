//
//  DrinkCategoryHeader.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import UIKit

class DrinkCategoryHeader: UITableViewHeaderFooterView {
    
    // MARK: - Outlets -
    @IBOutlet weak private var categoryLabel: UILabel!
    
    // MARK: - Interface -
    static func headerHeight() -> CGFloat { return 30.0 }
    
    func fillCategoryName(_ name: String) {
        categoryLabel.text = name
    }
}
