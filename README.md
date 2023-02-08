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
    
    /// Result of APIService invocation. `T` is either `Data` to return the raw data or `Defined Type` to apply JSON transformation to the returned data. The object models of the returned Open Library JSON data are specified in `OpenLibrarySearchResult`.
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

### 


```Swift
class APIRequestViewModel<T: Decodable>: ObservableObject, Requestable {
    @Published var searchTerm: String = ""
    
    @Published private(set) var result: T?
    @Published private(set) var error: Error?
    @Published private(set) var isRequesting: Bool = false
    
```
