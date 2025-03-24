//
//  RecipeListItemView.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import SwiftUI

struct RecipeListItemView: View {
     let model: RecipeListItemViewModel

  var body: some View {
      HStack {
          ImageView(model: ImageViewModel(imageService: model.imageService, imageSize: model.imageSize))
          VStack(alignment: .leading) {
              Text(model.name).font(model.nameFont)
              Text(model.cuisineMessage).font(model.cuisineFont)
          }
      }
  }
}
