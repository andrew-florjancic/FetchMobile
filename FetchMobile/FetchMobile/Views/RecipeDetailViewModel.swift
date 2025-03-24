//
//  RecipeDetailViewModel.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/24/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import UIKit
import SwiftUI

struct RecipeDetailViewModel {
    ///  The recipe name.
    let name: String
    
    /// The font for the recipe name.
    let nameFont: Font = .headline
    
    /// The cuisine type
    let cuisine: String
    
    /// A message to display the cuisine
    var cuisineMessage: String {
        "Cuisine: \(cuisine)"
    }
    
    /// The font for the cuisine message
    let cuisineFont: Font = .caption
    
    /// The url of the source, nil if it doesn't exist.
    let sourceURL: String?
    
    /// The text to display for the link to the source url.
    let sourceURLText: String = "Source Recipe"
    
    /// The url of the video, nil if it doesn't exist.
    let videoURL: String?
    
    /// The text to display for the link to the video url.
    let videoURLText: String = "Watch Video"
    
    /// The `ImageService` used to fetch images.
    let imageService: ImageService
    
    /// The height and width of the image.
    let imageSize: CGFloat = 200

    init(recipe: RecipeService.RecipeContainer.Recipe, networkComponent: NetworkComponent) {
        name = recipe.name
        cuisine = recipe.cuisine
        sourceURL = recipe.sourceURL
        videoURL = recipe.videoURL
        imageService = ImageService(networkComponent: networkComponent,
                                                           cache: NSCache<NSString, UIImage>(),
                                                           endpoint: recipe.imageLarge ?? "")
    }
}
