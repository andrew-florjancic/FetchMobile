//
//  RecipeServiceTests.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import XCTest
@testable import FetchMobile

final class RecipeServiceTests: XCTestCase {
    
    /// System under test
    var sut: RecipeService!

    /// Tests the RecipeService using an endpoint that returns valid data.
    func testValidRecipeEndpoint() async throws {
        sut = RecipeService(networkComponent: Mocks.RecipeService.valid.network)
        let recipes = try await sut.fetchRecipes()
        XCTAssertEqual(recipes.count, 63)
        XCTAssertEqual(recipes.first?.cuisine, "Malaysian")
        XCTAssertEqual(recipes.first?.name, "Apam Balik")
        XCTAssertEqual(recipes.first?.imageLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
        XCTAssertEqual(recipes.first?.imageSmall, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        XCTAssertEqual(recipes.first?.id, UUID(uuidString: "0C6CA6E7-E32A-4053-B824-1DBF749910D8"))
        XCTAssertEqual(recipes.first?.sourceURL, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
        XCTAssertEqual(recipes.first?.videoURL, "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    }
    
    /// Tests the RecipeService using an endpoint that returns malformed data.
    func testMalformedRecipeEndpoint() async throws {
        sut = RecipeService(networkComponent: Mocks.RecipeService.malformed.network)
        do {
            _ = try await sut.fetchRecipes()
            XCTFail("Expecting keyNotFound error to be thrown")
        } catch { }
    }
    
    /// Tests the RecipeService using an endpoint that returns valid data but an empty list of recipes.
    func testEmptyRecipeEndpoint() async throws {
        sut = RecipeService(networkComponent: Mocks.RecipeService.empty.network)
        let recipes = try await sut.fetchRecipes()
        XCTAssertTrue(recipes.isEmpty)
    }
}
