//
//  RecipeListView.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import SwiftUI

struct RecipeListView: View {

    /// The `RecipeLlistViewModel` used to  configure the current view.
    @ObservedObject var viewmodel: RecipeListViewModel
    
    /// The currently selected recipe will be displayed in a detail view
    @State var selectedRecipe: RecipeService.RecipeContainer.Recipe? = nil
    
    var body: some View {
        NavigationStack {
            Text(viewmodel.title)
            HStack {
                Menu(viewmodel.filterMenuTitle) {
                    Picker("", selection: $viewmodel.filterSelection) {
                        ForEach(RecipeListViewModel.CuisineType.allCases) { cuisine in
                            Text(cuisine.rawValue)
                        }
                    }
                    .pickerStyle(.inline)
                }
                .onChange(of: viewmodel.filterSelection) { _ in
                    Task { await viewmodel.filterAndSortRecipes() }
                }
                Spacer()
                Menu(viewmodel.sortMenuTitle) {
                    Picker("", selection: $viewmodel.sortingSelection) {
                        ForEach(RecipeListViewModel.SortingOption.allCases) { sortingOption in
                            Text(sortingOption.rawValue)
                        }
                    }
                    .pickerStyle(.inline)
                }
                .onChange(of: viewmodel.sortingSelection) { _ in
                        Task { await viewmodel.filterAndSortRecipes() }
                    }
            }
            .padding(.horizontal)
            List {
                switch(viewmodel.state) {
                case .loaded(let recipes):
                    ForEach(recipes) { recipe in
                        let model = RecipeListItemViewModel(recipe: recipe,
                                                            networkComponent: ProdNetworkComponent())
                        RecipeListItemView(model: model)
                            .onTapGesture {
                                selectedRecipe = recipe
                            }
                    }
                case .emptyFilter, .emptyNetwork, .error: Text(viewmodel.state.message)
                }
            }
            .refreshable { await viewmodel.fetchRecipes() }
            .task { await viewmodel.fetchRecipes() }
            .sheet(item: $selectedRecipe, onDismiss: { selectedRecipe = nil }) { recipe in
                let detailViewModel = RecipeDetailViewModel(recipe: recipe, networkComponent: ProdNetworkComponent())
                RecipeDetailView(model: detailViewModel)
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(viewmodel: RecipeListViewModel(recipeService: RecipeService(networkComponent: ProdNetworkComponent())))
    }
}
