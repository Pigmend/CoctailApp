//
//  DrinkProvider.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import Moya

enum DrinkProvider: BaseProvider {
    case listCategories
    case listDrinks(categoryName: String)
}

extension DrinkProvider: TargetType {
    
    var path: String {
        switch self {
        case .listCategories:
            return "list.php"
        case .listDrinks:
            return "filter.php"
        }
    }

    var task: Task {
        switch self {
        case .listCategories:
            let parameters = ["c": "list"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .listDrinks(let categoryName):
            let parameters = ["c": categoryName]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
