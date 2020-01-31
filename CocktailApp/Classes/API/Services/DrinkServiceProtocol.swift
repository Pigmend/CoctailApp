//
//  DrinkServiceProtocol.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import RxSwift

protocol DrinkServiceProtocol {
    
    @discardableResult func loadCategories() -> Observable<Categories>
    @discardableResult func loadDrinks(categoryName: String) -> Observable<Drinks>
}

