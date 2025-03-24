//
//  RecipeListView.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/18/25.
//

import SwiftUI

struct RecipeListView: View {

    /// The `RecipeLlistViewModel` used to  configure the current view.
    @ObservedObject var viewmodel: RecipeListViewModel
    
    /// The currently selected recipe will be displayed in a detail view
    @State var selectedRecipe: RecipeService.RecipeContainer.Recipe? = nil
    
    var body: some View {
        NavigationStack {
            Text("Demo App")
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
                case .empty, .error: Text(viewmodel.state.message)
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
