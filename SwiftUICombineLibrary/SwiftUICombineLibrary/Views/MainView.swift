//
//  MainView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "book.circle.fill")
                    Text("Dashboard")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search")
                }
            
            FavouriteView()
                .tabItem {
                    Image(systemName: "heart.circle.fill")
                    Text("Favourites")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
