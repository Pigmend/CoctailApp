//
//  UIView+LoadFromNib.swift
//  CocktailApp
//
//  Created by Ilya Pokrovsky on 24/1/20.
//  Copyright © 2020 Ilya Pokrovsky. All rights reserved.
//

import UIKit

public func instancetype<T>(object: Any?) -> T? {
    return object as? T
}

extension UIView {
    
    func setupFromNib() {
        let view = loadFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func loadFromNib() -> UIView {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError()
        }
        return view
    }
    
    static func place(view: UIView, on container: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(view)
        
        view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        
        view.layoutSubviews()
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
    
    class func fromXib(_ name: String? = nil) -> Self? {
        return instancetype(object: Bundle.main.loadNibNamed(name ?? self.className, owner: nil, options: nil)?.last)
    }
    
}
