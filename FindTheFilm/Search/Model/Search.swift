//
//  Recording.swift
//  FindTheFilm
//
//  Created by  石明杰 on 2020/10/21.
//

import Foundation

struct Search: Codable {
    let title: String
    let poster: String
    let year: String
    let imdbID: String
    
    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case poster = "Poster"
        case year = "Year"
        case imdbID = "imdbID"
    }
}
