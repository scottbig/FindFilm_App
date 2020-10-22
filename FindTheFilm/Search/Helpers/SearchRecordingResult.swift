//
//  RecordingResult.swift
//  FindTheFilm
//
// Created by  石明杰 on 2020/10/21.
//

import Foundation

struct RecordingsResult {
    let recordings: [Search]?
    let error: Error?
    let currentPage: Int
    let pageCount: Int
    
    var hasMorePages: Bool {
        return currentPage < pageCount
    }
    
    var nextPage: Int {
        return hasMorePages ? currentPage + 1 : currentPage
    }
    
}
