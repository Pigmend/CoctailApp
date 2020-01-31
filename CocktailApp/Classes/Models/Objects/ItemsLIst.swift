//
//  ItemsLIst.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//


import ObjectMapper

class ItemsLIst<T: Mappable>: NSObject, Mappable {
    
    var list: [T]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        list <- map["drinks"]
    }
}
