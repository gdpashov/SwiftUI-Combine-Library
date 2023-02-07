//
//  BookSimpleView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct BookSimpleView: View {
    var book: OpenLibrarySearchResultBook
    
    @StateObject
    fileprivate var imageRequestViewModel: APIRequestViewModel<Data>
    
    @FetchRequest
    fileprivate var fetchedFavouriteBooks: FetchedResults<FavouriteBook>
    
    init(book: OpenLibrarySearchResultBook) {
        self.book = book
        
        _imageRequestViewModel = StateObject(wrappedValue: APIRequestViewModel(urlString: book.mediumCoverImageUrlString, destinationType: Data.self))
        _fetchedFavouriteBooks = FetchRequest<FavouriteBook>(sortDescriptors: [], predicate: NSPredicate(format: "key == %@", book.key ?? ""))
    }
    
    var body: some View {
        NavigationLink {
            BookDetailView(book: book, imageRequestViewModel: imageRequestViewModel, fetchedFavouriteBooks: fetchedFavouriteBooks)
            
        } label: {
            VStack(alignment: .leading) {
                RequestableView(requestable: imageRequestViewModel) {
                    ImageView(imageData: imageRequestViewModel.result)
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(book.title ?? " ")
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(.black)
                        
                        Text(book.authorName?.first ?? " ")
                            .font(.caption2)
                            .lineLimit(1)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    IsFavouriteView(book: book, fetchedFavouriteBooks: fetchedFavouriteBooks)
                }
                
            }
            .padding(3.0)
        }
    }
}

struct BookSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        Text("To be implemented")
    }
}
