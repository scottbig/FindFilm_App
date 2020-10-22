//
//  ServiceResponse.swift
//  FindTheFilm
//
//  Created by  石明杰 on 2020/10/21.
//

import Foundation

//存電影資料
struct Film: Codable {
    var title: String
    var year: String
    var director: String
    var actors: String
    var plot: String
    var country: String
    var rating: String
    var poster: String
    
    //取得電影資料
    enum CodingKeys : String, CodingKey {
        case title = "Title"
        case year = "Year"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
        case country = "Country"
        case rating = "imdbRating"
        case poster = "Poster"
    }
    
}
