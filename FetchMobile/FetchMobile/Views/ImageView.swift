//
//  ImageView.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var model: ImageViewModel
    
    var body: some View {
        Image(uiImage: model.image)
            .resizable()
            .frame(width: model.imageSize, height: model.imageSize)
            .background(Rectangle().fill(model.backgroundColor))
            .task(id: model.image) { await model.fetchImage() }
  }
}
