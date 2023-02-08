//
//  BookDetailView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct BookDetailView: View {
    var book: OpenLibrarySearchResultBook
    
    /// Requests cover image. A progress indicator is shown while is running.
    @ObservedObject
    var imageRequestViewModel: APIRequestViewModel<Data>
    
    /// Fetches the record for the book key if it exists in `FavouriteBook` Core Data entity.
    var fetchedFavouriteBooks: FetchedResults<FavouriteBook>
    
    /// Requests book description.
    @StateObject
    fileprivate var bookPropertiesRequestViewModel: APIRequestViewModel<OpenLibraryBookProperties>
    
    init(book: OpenLibrarySearchResultBook, imageRequestViewModel: APIRequestViewModel<Data>, fetchedFavouriteBooks: FetchedResults<FavouriteBook>) {
        self.book = book
        self.imageRequestViewModel = imageRequestViewModel
        self.fetchedFavouriteBooks = fetchedFavouriteBooks
        
        _bookPropertiesRequestViewModel = StateObject(wrappedValue: APIRequestViewModel(urlString: AppConfiguration.default.openLibraryBookPropertiesUrlString.localized(book.key ?? ""), destinationType: OpenLibraryBookProperties.self))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16.0) {
                HStack() {
                    RequestableView(requestable: imageRequestViewModel) {
                        ImageView(imageData: imageRequestViewModel.result)
                    }
                    .frame(width: 80.0)
                    
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text(book.title ?? " ")
                            .font(.body)
                            .lineLimit(2)
                        
                        Text((book.authorName ?? []).joined(separator: ", "))
                            .font(.subheadline)
                            .lineLimit(2)
                        
                        Text((book.subject ?? []).joined(separator: ", "))
                            .font(.footnote)
                            .lineLimit(2)
                        
                        IsFavouriteView(book: book, fetchedFavouriteBooks: fetchedFavouriteBooks)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                RequestableView(requestable: bookPropertiesRequestViewModel) {
                    Text(bookPropertiesRequestViewModel.result?.description ?? "")
                }
                
                Spacer()
            }
        }
        .padding(16.0)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Text("To be implemented")
    }
}
