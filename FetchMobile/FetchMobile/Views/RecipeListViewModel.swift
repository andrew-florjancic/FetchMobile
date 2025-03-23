//
//  RecipeListViewModel.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation

/// A Model of the RecipeListView
@MainActor
class RecipeListViewModel: ObservableObject {
    
    /// The RecipeService used to fetch recipes from the backend.
    let recipeService: RecipeService
    
    /// States the model can be in, used to show state dependent views
    enum ModelState {
        case loaded([RecipeService.RecipeContainer.Recipe])
        case empty
        case error
        
        /// A message to be displayed to users describing the current state
        var message: String {
            switch(self) {
            case .loaded: return ""
            case .empty: return "No recipes are available at this time. Please check back later."
            case .error: return "Error fetching data. Pull to refresh or try again later."
            }
        }
    }
    
    /// The current state of the model, used to display loaded, empty, and error states in the view.
    @Published private(set) var state: ModelState = .loaded([])
    
    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    /// Fetches recipes and sets the model state
    func fetchRecipes() async {
        do {
            let recipes = try await recipeService.fetchRecipes()
            guard !recipes.isEmpty else {
                state = .empty
                return
            }
            state = .loaded(recipes)
        } catch {
            state = .error
        }
    }
}
