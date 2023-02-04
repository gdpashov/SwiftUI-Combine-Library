//
//  OpenLibrarySearchResult.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import Foundation

// Data model for searching Open Library (https://openlibrary.org/dev/docs/api/books)

// MARK: - OpenLibrarySearchResult

struct OpenLibrarySearchResult: Codable {
    let docs: [OpenLibrarySearchResultBook]?
    let works: [OpenLibrarySearchResultBook]?
    let openLibrarySearchResultNumFound: Int?
    
    enum CodingKeys: String, CodingKey {
        case docs, works
        case openLibrarySearchResultNumFound = "num_found"
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(OpenLibrarySearchResult.self, from: data)
    }
}

// MARK: - OpenLibrarySearchResult extension

extension OpenLibrarySearchResult {
    var books: [OpenLibrarySearchResultBook]? {
        works ?? docs
    }
}

// MARK: - OpenLibrarySearchResultBook

struct OpenLibrarySearchResultBook: Codable {
    let title, type: String?
    let key: String?
    let coverEditionKey: String?
    let authorName: [String]?
    let publishYear: [Int]?
    let subject: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case key
        case coverEditionKey = "cover_edition_key"
        case authorName = "author_name"
        case publishYear = "publish_year"
        case subject
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(OpenLibrarySearchResultBook.self, from: data)
    }
}

// MARK: - OpenLibrarySearchResultBook extension

extension OpenLibrarySearchResultBook {
    var mediumCoverImageUrlString: String {
        AppConfiguration.default.openLibraryMediumCoverImageUrlString.localized(coverEditionKey ?? "")
    }
}

// MARK: - Identifiable

extension OpenLibrarySearchResultBook: Identifiable {
    var id: String {
        key ?? UUID().uuidString
    }
}
