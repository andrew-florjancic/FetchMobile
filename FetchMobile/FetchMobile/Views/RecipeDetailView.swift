//
//  RecipeDetailView.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/24/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import SwiftUI

struct RecipeDetailView: View {
    
    /// The `RecipeDetailViewModel` used to configure the view.
    let model: RecipeDetailViewModel

  var body: some View {
      VStack {
          ImageView(model: ImageViewModel(imageService: model.imageService, imageSize: model.imageSize))
          Text(model.name).font(model.nameFont)
          Text(model.cuisineMessage).font(model.cuisineFont)
          if let urlString = model.sourceURL,
             let sourceURL = URL(string: urlString) {
              Link(model.sourceURLText, destination: sourceURL)
          }
          if let urlString = model.videoURL,
             let videoURL = URL(string: urlString) {
              Link(model.videoURLText, destination: videoURL)
          }
      }
  }
}
