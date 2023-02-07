//
//  FavouriteView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI
import CoreData

struct FavouriteView: View {
    @FetchRequest(
        sortDescriptors: []
    ) var favouriteBooks: FetchedResults<FavouriteBook>
    
    var body: some View {
        NavigationView {
            List(favouriteBooks) { favouriteBook in
                if let jsonData = favouriteBook.jsonContent, let book = try? OpenLibrarySearchResultBook(jsonData: jsonData) {
                    BookAdvancedView(book: book)
                        .buttonStyle(.plain)
                } else {
                    Text("Wrong data for \(favouriteBook.key ?? "")")
                }
            }
        }
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}
