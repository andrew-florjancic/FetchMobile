//
//  ImageViewModel.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import UIKit
import SwiftUI

@MainActor
class ImageViewModel: ObservableObject {
    /// The `ImageService` used to fetch images.
    let imageService: ImageService
    
    /// The height and width of the image.
    let imageSize: CGFloat
    
    /// The background color of the image view.
    let backgroundColor: Color = .secondary
    
    /// The  current image to be displayed.
    @Published private(set) var image: UIImage = UIImage()
    
    
    /// Creates a new `ImageViewModel`.
    /// - Parameters:
    ///   - imageService: The service used to fetch images from the backend.
    ///   - imageSize: The height and width the image.
    init(imageService: ImageService, imageSize: CGFloat) {
        self.imageService = imageService
        self.imageSize = imageSize
    }
    
    /// Fetches the image from the backend and published the result if successful.
    func fetchImage() async {
        do {
            try await image = imageService.fetchImage()
        } catch {
            // Future Consideration: Show some error state image to differentiate from unloaded/loading image
            // For the purpose of this exercise we can skip this
        }
    }
}
