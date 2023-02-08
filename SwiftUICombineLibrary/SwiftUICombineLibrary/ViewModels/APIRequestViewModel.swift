//
//  APIRequestViewModel.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import Foundation
import Combine

class APIRequestViewModel<T: Decodable>: ObservableObject, Requestable {
    @Published var searchTerm: String = ""
    
    /// Observable property for result of APIService invocation. `T` is either `Data` to return the raw data or `Defined Type` to apply JSON transformation to the returned data. The object models of the returned Open Library JSON data are specified in `OpenLibrarySearchResult`.
    @Published private(set) var result: T?
    
    /// Error that may arise during execution.
    @Published private(set) var error: Error?
    
    /// Indicates whether it is running or not. To be used in progress indicators.
    @Published private(set) var isRequesting: Bool = false
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    /// Creates a subscriber to `APIService` publisher. On receiving data: the returned data is set into `result`, property `error` holds the error if execution has failed.
    init(urlString: String, destinationType: T.Type, isSearching: Bool = false) {
        $searchTerm
            .handleEvents(receiveOutput: { value in
                self.error = nil
                self.isRequesting = true
            })
            .map { searchTerm -> AnyPublisher<T, Error> in
                self.isRequesting = true
                
                if isSearching {
                    let escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                    return APIService.requestDataPublisher(urlString: urlString.localized(escapedSearchTerm), destinationType: destinationType)
                    
                } else {
                    return APIService.requestDataPublisher(urlString: urlString, destinationType: destinationType)
                }
                
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = error
                        self.isRequesting = false
                    }
                },
                receiveValue: { result in
                    self.result = result
                    self.isRequesting = false
                })
            .store(in: &cancellables)
    }
}
