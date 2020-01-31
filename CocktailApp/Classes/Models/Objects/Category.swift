//
//  Category.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import ObjectMapper

typealias Categories = ItemsLIst<Category>

class Category: NSObject, Mappable {
    
    var name: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["strCategory"]
    }
}
