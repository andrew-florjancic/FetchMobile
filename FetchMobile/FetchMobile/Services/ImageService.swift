//
//  ImageService.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation
import UIKit // Shhhhh I'm using UIKit just to snag the images, there's probably a better more SwiftUI appropriate way to do this but AsyncImage from SwiftUI was pretty disappointing.

/// Fetches images from the backend and stored them in a cache
class ImageService {
    
    /// The network component used to fetch data.
    private let networkComponent: NetworkComponent
    
    /// The endpoint of the image to fetch.
    private let endpoint: String
    
    /// A cache to store the `UIImage` after fetching.
    private let cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    
    /// Creates a new ImageService.
    /// - Parameters:
    ///   - networkComponent: The network component used to fetch data.
    ///   - endpoint: The endpoint of the image to fetch.
    init(networkComponent: NetworkComponent, endpoint: String) {
        self.networkComponent = networkComponent
        self.endpoint = endpoint
    }
    
    
    /// Fetches the `UIImage` from the endpoint, or from the cache if previously fetched.
    /// - Returns: A UIImage from the endpoint, if none exists a placeholder empty UIImage will be returned.
    func fetchImage() async throws -> UIImage {
        if let cachedImage = cache.object(forKey: endpoint as NSString) {
            return cachedImage
        }
        guard let url = URL(string: endpoint) else { throw URLError(.badURL) }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        let (data, _) = try await networkComponent.fetchData(for: request)
        guard let image = UIImage(data: data) else {
            let placeholder = UIImage()
            cache.setObject(placeholder, forKey: endpoint as NSString)
            return placeholder
        }
        cache.setObject(image, forKey: endpoint as NSString)
        return image
    }
}
