//
//  BookSimpleView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct BookSimpleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var book: OpenLibrarySearchResultBook
    
    @StateObject
    fileprivate var imageRequestViewModel: APIRequestViewModel<Data>
    
    @StateObject
    fileprivate var favouriteBookViewModel: PersistanceFavouriteBookViewModel
    
    init(book: OpenLibrarySearchResultBook) {
        self.book = book
        
        _imageRequestViewModel = StateObject(wrappedValue: APIRequestViewModel(urlString: book.mediumCoverImageUrlString, destinationType: Data.self))
        _favouriteBookViewModel = StateObject(wrappedValue: PersistanceFavouriteBookViewModel(key: book.key ?? ""))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            RequestableView(requestable: imageRequestViewModel) {
                ImageView(imageData: imageRequestViewModel.result)
            }
            
            Spacer()
            
            HStack {
                VStack {
                    Text(book.title ?? " ")
                        .font(.footnote)
                        .lineLimit(1)
                    
                    Text(book.authorName?.first ?? " ")
                        .font(.caption2)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    favouriteBookViewModel.toggleIsFavourite()
                } label: {
                    IsFavouriteView(isFavourite: favouriteBookViewModel.isFavourite)
                }
            }
        }
        .padding(3.0)
        .onAppear {
            if favouriteBookViewModel.viewContext == nil {
                favouriteBookViewModel.viewContext = viewContext
                favouriteBookViewModel.fetch()
            }
        }
    }
}

struct ImageView: View {
    var imageData: Data?
    
    var body: some View {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
        } else {
            Image(systemName: "book")
                .foregroundColor(.gray)
        }
    }
}

struct IsFavouriteView: View {
    var isFavourite: Bool?
    
    var body: some View {
        switch isFavourite {
        case true:
            Image(systemName: "heart.circle.fill")
        case false:
            Image(systemName: "heart.circle")
                .foregroundColor(.gray)
        default:
            Image(systemName: "heart.circle")
                .foregroundColor(.clear)
        }
    }
}

struct BookSimpleView_Previews: PreviewProvider {
    static var previews: some View {
        Text("To be implemented")
    }
}
