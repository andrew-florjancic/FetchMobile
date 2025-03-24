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
    
    /// The current state of the model, used to display loaded, empty, and error states in the view.
    @Published private(set) var state: ModelState = .loaded([])
    
    @Published var filterSelection: CuisineType = .all
    
    @Published var sortingSelection: SortingOption = .alphabeticalAscending
    
    /// The RecipeService used to fetch recipes from the backend.
    let recipeService: RecipeService
    
    /// Unfiltered and unsorted recipes straight from the service.
    private var recipes: [RecipeService.RecipeContainer.Recipe] = []
    
    let title: String = "Fetch Mobile"
    
    let filterMenuTitle: String = "Filter"
    
    let sortMenuTitle: String = "Sort"
    
    /// States the model can be in, used to show state dependent views
    enum ModelState {
        case loaded([RecipeService.RecipeContainer.Recipe])
        case emptyFilter
        case emptyNetwork
        case error
        
        /// A message to be displayed to users describing the current state
        var message: String {
            switch(self) {
            case .loaded: return ""
            case .emptyNetwork: return "No recipes are available at this time. Please check back later."
            case .emptyFilter: return "No recipes for the current filter. Try selecting a different filter."
            case .error: return "Error fetching data. Pull to refresh or try again later."
            }
        }
    }
    
    /// Options for sorting recipes.
    enum SortingOption: String, CaseIterable, Identifiable {
        case alphabeticalAscending = "A -> Z"
        case alphabeticalDescending = "Z -> A"
        var id: Self { self }
    }
    
    /// Different types of cuisine for a recipe
    enum CuisineType: String, CaseIterable, Identifiable {
        case all = "All"
        case american = "American"
        case british = "British"
        case canadian = "Canadian"
        case croatian = "Croatian"
        case french = "French"
        case greek = "Greek"
        case italian = "Italian"
        case malaysian = "Malaysian"
        case polish = "Polish"
        case portuguese = "Portuguese"
        case russian = "Russian"
        case tunisian = "Tunisian"
        // If there are other cuisines we are expexting that weren't included in the test endpoint we can add them
        // We coulld also introduce an 'other' cuisine type for all that are not listed.
        
        var id: Self { self }
    }

    init(recipeService: RecipeService) {
        self.recipeService = recipeService
    }
    
    /// Sorts and filters the recipes and publishes the new array of recipes
    func filterAndSortRecipes() async {
        let recipes = self.recipes
            .filter {  recipe in
                switch(filterSelection) {
                case .all: return true
                default: return recipe.cuisine == filterSelection.rawValue
                }
            }
            .sorted(by: { (lhs, rhs) in
                switch(sortingSelection) {
                case .alphabeticalAscending: return lhs.name < rhs.name
                case .alphabeticalDescending: return lhs.name > rhs.name
                }
            })
        guard !recipes.isEmpty else {
            state = .emptyFilter
            return
        }
        state = .loaded(recipes)
    }
    
    /// Fetches recipes and sets the model state
    func fetchRecipes() async {
        do {
            let recipes = try await recipeService.fetchRecipes()
            guard !recipes.isEmpty else {
                state = .emptyNetwork
                return
            }
            self.recipes = recipes
            await filterAndSortRecipes()
        } catch {
            state = .error
        }
    }
}
