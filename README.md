# SwiftUI-Combine-Library

## About

This is an iOS mobile app for browsing Open Library catalog. The main goal is to demonstrate the usage of SwiftUI, Combine and Core Data iOS SDK frameworks.

## Overview

The main views are:
- Dashboard: Contains a couple of popular book categories presented as scrollable horizontal lists.

  <img src="/Assets/Images/01_DashboardScreenShot.jpg" width="200"/>
  
  > Browse the most popular book categories.

- Search: Allows searching in Open Library's catalog by text.

  <img src="/Assets/Images/02_SearchScreenShot.jpg" width="200"/>
  
  > Search in the library catalog.

- Favourite: Contains a list of books that the user is marked to review later.

  <img src="/Assets/Images/03_FavouritesScreenShot.jpg" width="200"/>
  
  > See your favourite books.

- Details about book

  <img src="/Assets/Images/04_BookDetailScreenShot.jpg" width="200"/>
  
  > See book authors and description.

## App Structure

### `API`/`APIService`

> Uses Combine framework.

Creates a publisher that requests an API service, validates the response, and decodes the result JSON data into a specified object.

Returns `AnyPublisher<T, Error>` where:

- `T` is either `Data` to return the raw data or `Defined Type` to apply JSON transformation to the returned data. The object models of the returned Open Library JSON data are specified in `Models`/`OpenLibrarySearchResult`.

- `Error` is the error that may arise during execution.

### `ViewModels`/`APIRequestViewModel`

> Uses Combine framework.

Creates a subscriber to `APIService` publisher.

```Swift
class APIRequestViewModel<T: Decodable>: ObservableObject, Requestable {
    ...
    
    /// Observable property for result of APIService invocation. `T` is either `Data` to return the raw data or `Defined Type` to apply JSON transformation to the returned data. The object models of the returned Open Library JSON data are specified in `OpenLibrarySearchResult`.
    @Published private(set) var result: T?
    
    /// Error that may arise during execution.
    @Published private(set) var error: Error?
    
    /// Indicates whether it is running or not. To be used in progress indicators.
    @Published private(set) var isRequesting: Bool = false
    
    ...
    
    /// Creates a subscriber to `APIService` publisher. On receiving data: the returned data is set into `result`, property `error` holds the error if execution has failed.
    init(urlString: String, destinationType: T.Type, isSearching: Bool = false) {
        ...
    }
    ...    
}
    
```

### `Views`/`Common`/`HList`

> Uses SwiftUI framework.

Creates a horizontal list with a preferred item width. The real item is calculated in such a way that the last item to be shown in half (to indicate that there are more items) and width to be as closer to the preferred one as possible.


### `Views`/`Book`/`BookSimpleView` and `BookAdvancedView`

> Uses SwiftUI and Core Data frameworks.

Create a simple/advanced view for the book as navigation link to `BookDetailView`. The cover image is requested and shown. The Core Data container is checked if the book is recorded as `FavouriteBook` and the record is observed for changes.

```Swift
struct BookSimpleView: View {
    var book: OpenLibrarySearchResultBook
    
    /// Requests cover image. A progress indicator is shown while is running.
    @StateObject
    fileprivate var imageRequestViewModel: APIRequestViewModel<Data>
    
    /// Fetches the record for the book key if it exists in `FavouriteBook` Core Data entity.
    @FetchRequest
    fileprivate var fetchedFavouriteBooks: FetchedResults<FavouriteBook>
    
    init(book: OpenLibrarySearchResultBook) {
        self.book = book
        
        _imageRequestViewModel = StateObject(wrappedValue: APIRequestViewModel(urlString: book.mediumCoverImageUrlString, destinationType: Data.self))
        // Initialize fetch request
        _fetchedFavouriteBooks = FetchRequest<FavouriteBook>(sortDescriptors: [], predicate: NSPredicate(format: "key == %@", book.key ?? ""))
    }
    
    var body: some View {
        ...
    }
}
    
```

### `Views`/`Book`/`BookDetailView`

> Uses SwiftUI and Core Data frameworks.

Similar to `BookSimpleView` and `BookAdvancedView`. An additional request for book description is executed.


### `Views`/`DashboardView`

> Uses SwiftUI framework.

Creates a couple of popular book categories presented as scrollable horizontal lists `HList`.

### `Views`/`SearchView`

> Uses SwiftUI framework.

Allows searching in Open Library's catalog by text.

```Swift
struct SearchView: View {
    ...
    
    var body: some View {
        NavigationView {
            RequestableView(requestable: booksRequestViewModel) {
                ...
            }
        }
        .searchable(text: $booksRequestViewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
    }
}
    
```

### `Views`/`FavouriteView`

> Uses SwiftUI and Core Data frameworks.

Contains a list of books that the user is marked to review later. All entities in `FavouriteBook` are fetched and they are observed for changes.

```Swift
struct FavouriteView: View {
    @FetchRequest(
        sortDescriptors: []
    ) var favouriteBooks: FetchedResults<FavouriteBook>
    
    var body: some View {
        ...
    }
}
    
```
