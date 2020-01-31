//
//  Drink.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import ObjectMapper

typealias Drinks = ItemsLIst<Drink>

class Drink: Mappable {
    
    var id: Int?
    var name: String?
    var imageUrl: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["idDrink"]
        name <- map["strDrink"]
        imageUrl <- map["strDrinkThumb"]
    }
}

