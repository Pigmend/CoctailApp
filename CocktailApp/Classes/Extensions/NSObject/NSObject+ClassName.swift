//
//  NSObject+ClassName.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import UIKit

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
}
