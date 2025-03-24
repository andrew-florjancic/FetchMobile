//
//  RecipeListItemViewModel.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

/// ViewModel for a `RecipeListItemView`.
struct RecipeListItemViewModel {
    /// The recipe name.
    let name: String
    
    /// The font for the recipe name.
    let nameFont: Font = .headline
    
    /// The cuisine type.
    let cuisine: String
    
    /// A message to display the cuisine
    var cuisineMessage: String {
        "Cuisine: \(cuisine)"
    }
    
    /// The font for the cuisine message
    let cuisineFont: Font = .caption
    
    /// The `ImageService` used to fetch images.
    let imageService: ImageService
    
    /// The height and width of the image.
    let imageSize: CGFloat = 50
    
    
    /// Creates a new `RecipeListItemViewModel`.
    /// - Parameters:
    ///   - recipe: The recipe model from the backend
    ///   - networkComponent: A `NetworkComponent` used to make network requests.
    init(recipe: RecipeService.RecipeContainer.Recipe, networkComponent: NetworkComponent) {
        name = recipe.name
        cuisine = recipe.cuisine
        imageService = ImageService(networkComponent: networkComponent,
                                    cache: NSCache<NSString, UIImage>(),
                                    endpoint: recipe.imageSmall ?? "")
    }
}
