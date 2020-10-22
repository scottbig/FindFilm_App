//
//  ServiceResponse.swift
//  FindTheFilm
//
//  Created by  石明杰 on 2020/10/21.
//

import Foundation

struct ServiceResponse: Codable {
    var search: [Search]
    var totalResults: String
    
    enum CodingKeys : String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
    }
}
