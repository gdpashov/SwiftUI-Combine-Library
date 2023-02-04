//
//  DashboardView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("Trending Books")
                    .font(.title2)
                
                DashboardBooksView(urlString: AppConfiguration.default.openLibraryTrendingUrlString)
                
                Spacer()
                Spacer()
                
                Text("Classic Books")
                    .font(.title2)
                
                DashboardBooksView(urlString: AppConfiguration.default.openLibraryClassicUrlString)
                
                Spacer()
                Spacer()
                
                Text("Travel Books")
                    .font(.title2)
                
                DashboardBooksView(urlString: AppConfiguration.default.openLibraryTravelUrlString)
                
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct DashboardBooksView: View {
    var urlString: String
    
    @StateObject
    fileprivate var booksRequestViewModel: APIRequestViewModel<OpenLibrarySearchResult>
    
    init(urlString: String) {
        self.urlString = urlString
        
        _booksRequestViewModel = StateObject(wrappedValue: APIRequestViewModel(urlString: urlString, destinationType: OpenLibrarySearchResult.self))
    }
    
    var body: some View {
        RequestableView(requestable: booksRequestViewModel) {
            if let books = booksRequestViewModel.result?.books {
                if !books.isEmpty {
                    HList(numberOfItems: books.count) { index in
                        BookSimpleView(book: books[index])
                            .border(.gray)
                    }
                } else {
                    Text("No books")
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200.0)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
