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

`API`/`APIService`

Creates a publisher that requests an API service, validates the response, and decodes the result JSON data into specified object.
Returns `AnyPublisher<T, Error>` where `T` is either `Data` to return raw data or `Defined Type` to aplly JSON transformation of returned data.

```Swift
<!DOCTYPE html>
<html>
    <head>
        <mate charest="utf-8" />
        <title>Hello world!</title>
    </head>
    <body>
        <h1>Hello world!</h1>
    </body>
</html>
```
