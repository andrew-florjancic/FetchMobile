//
//  Mock.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/21/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation
import UIKit

/// A Mock with a filename and file extension containing mock data.
protocol Mock {
    /// The name of the file containing mock data.
    var fileName: String { get }
    /// The file extension of the file containing mock data.
    var fileExtension: FileExtension { get }
}

extension Mock {
    /// The `MockNetworkComponent` for the mock.
    var network: MockNetworkComponent {
        MockNetworkComponent(fileName: fileName, fileExtension: fileExtension)
    }
}

/// An enum that holds mocks for different tests.
enum Mocks { }

// MARK: ImageService Mocks
extension Mocks {
    enum ImageService: Mock {
        case apamBalikImageSmall
        case apamBalikImageLarge
        case invalidEndpoint
        
        var fileName: String {
            switch(self) {
            case .apamBalikImageSmall: return "apam-balik-small"
            case .apamBalikImageLarge: return "apam-balik-large"
            case .invalidEndpoint: return ""
            }
        }
        
        var fileExtension: FileExtension { .jpg }
        
        var endpoint: String {
            switch(self) {
            case .apamBalikImageSmall: return ""
            case .apamBalikImageLarge: return "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"
            case .invalidEndpoint: return ""
            }
        }
        
        /// Returns an image for the current mock file.
        /// - Parameter bundle: The `Bundle` where the mock file is located.
        /// - Returns: An image created from the mock file data.
        func image(from bundle: Bundle) throws -> UIImage {
            guard let url = bundle.url(forResource: fileName, withExtension: fileExtension.rawValue) else {
                throw TestingError.invalidURL
            }
            guard let image = UIImage(contentsOfFile: url.path) else {
                throw TestingError.invalidImage
            }
            return image
        }
    }
}

// MARK: RecipeService Mocks
extension Mocks {
    enum RecipeService: Mock {
        case valid
        case empty
        case malformed
        
        var fileName: String {
            switch(self) {
            case .valid: return "recipes"
            case .empty: return "recipes-empty"
            case .malformed: return "recipes-malformed"
            }
        }
        
        var fileExtension: FileExtension { .json }
    }
}
