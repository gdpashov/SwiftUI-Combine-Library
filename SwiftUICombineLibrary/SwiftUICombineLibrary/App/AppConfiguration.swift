//
//  AppConfiguration.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import Foundation

class AppConfiguration {
    static let `default` = AppConfiguration()
    
    var openLibraryTrendingUrlString = "https://openlibrary.org/trending/daily.json"
    
    var openLibraryClassicUrlString = "https://openlibrary.org/read.json"
    
    var openLibraryTravelUrlString = "https://openlibrary.org/search.json?subject=travel"
    
    var openLibrarySearchUrlString = "https://openlibrary.org/search.json?q=%@"
    
    var openLibraryBookPropertiesUrlString = "https://openlibrary.org%@.json"
    
    var openLibraryMediumCoverImageUrlString = "https://covers.openlibrary.org/b/olid/%@-M.jpg"
}
