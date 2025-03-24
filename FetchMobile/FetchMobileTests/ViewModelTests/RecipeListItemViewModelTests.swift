//
//  RecipeListItemViewModelTests.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import XCTest
@testable import FetchMobile

final class RecipeListItemViewModelTests: XCTestCase {
    
    /// System under test.
    var sut: RecipeListItemViewModel!

    /// Tests the creation of a new RecipeListItemViewModel
    func testInit() async throws {
        let mockRecipe = try await Mocks.Recipe.apamBalik.getMockRecipe()
        sut = RecipeListItemViewModel(recipe: mockRecipe, networkComponent: Mocks.ImageService.apamBalikImageLarge.network)
        XCTAssertEqual(sut.name, mockRecipe.name)
        XCTAssertEqual(sut.nameFont, .headline)
        XCTAssertEqual(sut.cuisine, mockRecipe.cuisine)
        XCTAssertEqual(sut.cuisineMessage, "Cuisine: \(mockRecipe.cuisine)")
        XCTAssertEqual(sut.cuisineFont, .caption)
        XCTAssertEqual(sut.imageSize, 50)
    }
}
