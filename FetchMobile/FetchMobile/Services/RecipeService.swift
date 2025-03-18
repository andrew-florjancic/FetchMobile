//
//  RecipeService.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation

/// A service that fetches recipes from the recipe endpoint using the provided `NetworkComponent`.
class RecipeService {
    
    /// The network component used to fetch data.
    private let networkComponent: NetworkComponent
    
    /// The endpoint with all those tasty recipes we want to get
    private let endpoint: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    /*
     Also let's leave these not so tasty recipe endpoints here to make my life easier during development.
     If this was a more serious application then I would set up a more in depth demo app to allow the
     user/developer/tester to select from any of these predefined endpoints in addition to offering
     selectable mock responses to easily verify app behavior for odd edge cases like long loading states
     and error states. All of that is out of scope for this project, we currently lack funding $$$ :'(
     private let endpoint: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
     private let endpoint: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    */
    
    init(networkComponent: NetworkComponent) {
        self.networkComponent = networkComponent
    }
    
    
    /// Fetches recipes from the recipe endpoint and delivers the data asynchronously.
    /// - Returns: An array of recipes.
    func fetchRecipes() async throws -> [RecipeContainer.Recipe] {
        guard let url = URL(string: endpoint) else {
            // We really could and probably should create some of our own custom Errors for enhanced error handling but that sounds like a post employment task.
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        let data = try await networkComponent.fetchData(for: request)
        // For the purpose of this exercise we will ignore the response and just decode the data
        let recipeContainer = try JSONDecoder().decode(RecipeContainer.self, from: data)
        return recipeContainer.recipes
    }
    
    /// A Codable representation of the expected recipe JSON data
    struct RecipeContainer: Codable {
        let recipes: [Recipe]
        
        struct Recipe: Identifiable, Codable {
            let cuisine: String
            let name: String
            let imageLarge: String?
            let imageSmall: String?
            let id: UUID
            let sourceURL: String?
            let videoURL: String?
            
            enum CodingKeys: String, CodingKey {
                case cuisine
                case name
                case imageLarge = "photo_url_large"
                case imageSmall = "photo_url_small"
                case id = "uuid"
                case sourceURL = "source_url"
                case videoURL = "youtube_url"
            }
        }
    }
}
