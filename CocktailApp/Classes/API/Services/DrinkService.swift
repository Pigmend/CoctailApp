//
//  DrinkService.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import Moya
import RxSwift
import Moya_ObjectMapper

class DrinkService: DrinkServiceProtocol {
    
    private var drinkProvider = MoyaProvider<DrinkProvider>()
    
    @discardableResult func loadCategories() -> Observable<Categories> {
        return drinkProvider.rx.request(.listCategories).mapObject(Categories.self).asObservable()
    }
    
    @discardableResult func loadDrinks(categoryName: String) -> Observable<Drinks> {
        return drinkProvider.rx.request(.listDrinks(categoryName: categoryName)).mapObject(Drinks.self).asObservable()
    }
}
