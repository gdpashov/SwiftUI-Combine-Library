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
    
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(OpenLibrarySearchResult.self, from: jsonData)
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
    
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(OpenLibrarySearchResultBook.self, from: jsonData)
    }
    
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
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

// MARK: - OpenLibraryBookProperties

struct OpenLibraryBookProperties: Codable {
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.description = try container.decode(String.self, forKey: .description)
        } catch DecodingError.keyNotFound(_, _) {
            self.description = nil
        } catch DecodingError.typeMismatch {
            let typeValue = try container.decode(OpenLibraryTypeValue<String>.self, forKey: .description)
            self.description = typeValue.value
        }
    }
    
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(OpenLibraryBookProperties.self, from: jsonData)
    }
    
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

// MARK: - OpenLibraryTypeValue

struct OpenLibraryTypeValue<V: Codable>: Codable {
    let type: String?
    let value: V
}
