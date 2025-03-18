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

    func testValidRecipeEndpoint() async throws {
        sut = RecipeService(networkComponent: MockNetworkComponent(fileName: "recipes"))
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
    
    func testMalformedRecipeEndpoint() async throws {
        sut = RecipeService(networkComponent: MockNetworkComponent(fileName: "recipes-malformed"))
        do {
            _ = try await sut.fetchRecipes()
            XCTFail("Expecting keyNotFound error to be thrown")
        } catch { }
    }
    
    func testEmptyRecipeEndpoint() async throws {
        sut = RecipeService(networkComponent: MockNetworkComponent(fileName: "recipes-empty"))
        let recipes = try await sut.fetchRecipes()
        XCTAssertTrue(recipes.isEmpty)
    }
}
