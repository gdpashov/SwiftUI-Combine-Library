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
    
    @Published private(set) var result: T?
    @Published private(set) var error: Error?
    @Published private(set) var isRequesting: Bool = false
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
