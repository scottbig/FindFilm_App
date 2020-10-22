//
//  PropertyNames.swift
//  FindTheFilm
//
//  Created by  石明杰 on 2020/10/21.
//

import Foundation

extension Film: PropertyNames {
    
}

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
}
