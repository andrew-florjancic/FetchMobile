//
//  RecipeListView.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/18/25.
//

import SwiftUI

struct RecipeListView: View {

    @ObservedObject var viewmodel: RecipeListViewModel
    
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
                    }
                case .empty, .error: Text(viewmodel.state.message)
                }
            }
            .refreshable { await viewmodel.fetchRecipes() }
            .task { await viewmodel.fetchRecipes() }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(viewmodel: RecipeListViewModel(recipeService: RecipeService(networkComponent: ProdNetworkComponent())))
    }
}
