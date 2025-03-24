//
//  RecipeDetailViewModelTests.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/24/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import XCTest
@testable import FetchMobile

final class RecipeDetailViewModelTests: XCTestCase {

    /// System under test.
    var sut: RecipeDetailViewModel!

    /// Tests the creation of a new RecipeDetailViewModel
    func testInit() async throws {
        let mockRecipe = try await Mocks.Recipe.apamBalik.getMockRecipe()
        sut = RecipeDetailViewModel(recipe: mockRecipe, networkComponent: Mocks.ImageService.apamBalikImageLarge.network)
        XCTAssertEqual(sut.name, mockRecipe.name)
        XCTAssertEqual(sut.nameFont, .headline)
        XCTAssertEqual(sut.cuisine, mockRecipe.cuisine)
        XCTAssertEqual(sut.cuisineMessage, "Cuisine: \(mockRecipe.cuisine)")
        XCTAssertEqual(sut.cuisineFont, .caption)
        XCTAssertEqual(sut.imageSize, 200)
        XCTAssertEqual(sut.sourceURL, mockRecipe.sourceURL)
        XCTAssertEqual(sut.sourceURLText, "Source Recipe")
        XCTAssertEqual(sut.videoURL, mockRecipe.videoURL)
        XCTAssertEqual(sut.videoURLText, "Watch Video")
    }
}
