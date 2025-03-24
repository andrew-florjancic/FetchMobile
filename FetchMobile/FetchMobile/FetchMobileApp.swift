//
//  FetchMobileApp.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import SwiftUI

@main
struct FetchMobileApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewmodel: RecipeListViewModel(recipeService: RecipeService(networkComponent: ProdNetworkComponent())))
        }
    }
}
