//
//  IsFavouriteView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 7.02.23.
//

import SwiftUI

struct IsFavouriteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var book: OpenLibrarySearchResultBook
    var fetchedFavouriteBooks: FetchedResults<FavouriteBook>
    
    var body: some View {
        let favouriteBook = fetchedFavouriteBooks.first
        
        Button {
            if favouriteBook != nil {
                viewContext.delete(favouriteBook!)
                
            } else {
                do {
                    let favouriteBook = FavouriteBook(context: viewContext)
                    favouriteBook.key = book.key
                    favouriteBook.jsonContent = try book.toJSONData()
                    
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    fatalError("Unresolved error \(error)")
                }
            }
            
        } label: {
            if favouriteBook != nil {
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "heart.circle")
                    .foregroundColor(.gray)
            }
        }
    }
}
