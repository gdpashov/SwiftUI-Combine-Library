//
//  PersistanceFavouriteBookViewModel.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import CoreData

class PersistanceFavouriteBookViewModel: ObservableObject, Requestable {
    /// Get a reference to a NSManagedObjectContext
    var viewContext: NSManagedObjectContext!
    
    private var key: String
    private var favouriteBook: FavouriteBook?
    
    @Published private(set) var isFavourite: Bool?
    @Published private(set) var error: Error?
    @Published private(set) var isRequesting: Bool = false
    
    init(key: String) {
        self.key = key
    }
    
    func fetch() {
        self.error = nil
        self.isRequesting = true
        
        defer {
            self.isRequesting = false
        }
        
        let fetchRequest = FavouriteBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "key == %@", key
        )
        
        // Perform the fetch request to get the objects matching the predicate
        do {
            let objects = try viewContext.fetch(fetchRequest)
            favouriteBook = objects.first
            isFavourite = (favouriteBook != nil)
        } catch {
            self.error = error
        }
    }
    
    func save() {
        self.error = nil
        self.isRequesting = true
        
        defer {
            self.isRequesting = false
        }
        
        if favouriteBook == nil {
            favouriteBook = FavouriteBook(context: viewContext)
        }
        
        favouriteBook?.key = key
        
        do {
            try viewContext.save()
            isFavourite = (favouriteBook != nil)
        } catch {
            self.error = error
        }
    }
    
    func delete() {
        self.error = nil
        self.isRequesting = true
        
        defer {
            self.isRequesting = false
        }
        
        if favouriteBook != nil {
            viewContext.delete(favouriteBook!)
            favouriteBook = nil
        }
        
        isFavourite = (favouriteBook != nil)
    }
    
    func toggleIsFavourite() {
        guard let isFavourite = isFavourite else {
            return
        }
        
        if isFavourite {
            delete()
        } else {
            save()
        }
    }
}
