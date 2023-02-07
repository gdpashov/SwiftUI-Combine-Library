//
//  SearchView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct SearchView: View {
    @StateObject
    fileprivate var booksRequestViewModel = APIRequestViewModel(urlString: AppConfiguration.default.openLibrarySearchUrlString, destinationType: OpenLibrarySearchResult.self, isSearching: true)
    
    var body: some View {
        NavigationView {
            RequestableView(requestable: booksRequestViewModel) {
                if let books = booksRequestViewModel.result?.books {
                    if !books.isEmpty {
                        List(books) { book in
                            BookAdvancedView(book: book)
                                .buttonStyle(.plain)
                        }
                    } else {
                        Text("No books")
                    }
                }
            }
        }
        .searchable(text: $booksRequestViewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
