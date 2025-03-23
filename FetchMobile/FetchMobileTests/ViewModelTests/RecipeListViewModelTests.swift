//
//  RecipeListViewModelTests.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import XCTest
import Combine
@testable import FetchMobile

extension RecipeService.RecipeContainer.Recipe: Equatable {
    public static func == (lhs: RecipeService.RecipeContainer.Recipe, rhs: RecipeService.RecipeContainer.Recipe) -> Bool {
        return lhs.id == rhs.id &&
        lhs.cuisine == rhs.cuisine &&
        lhs.imageLarge == rhs.imageLarge &&
        lhs.imageSmall == rhs.imageSmall &&
        lhs.name == rhs.name &&
        lhs.sourceURL == rhs.sourceURL &&
        lhs.videoURL == rhs.videoURL
    }
}

extension RecipeListViewModel.ModelState: Equatable {
    public static func == (lhs: FetchMobile.RecipeListViewModel.ModelState, rhs: FetchMobile.RecipeListViewModel.ModelState) -> Bool {
        switch(lhs, rhs) {
        case (.error, .error), (.empty, .empty): return lhs.message == rhs.message
        case (.loaded(let lhsRecipes), .loaded(let rhsRecipes)): return lhsRecipes == rhsRecipes
        default: return false
        }
    }
}

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    
    /// System under test.
    var sut: RecipeListViewModel!
    
    /// Tests the published `state` variable after fetching recipe data with valid recipes.
    func testStateLoaded() async throws {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.valid.network)
        sut = RecipeListViewModel(recipeService: mockService)
        XCTAssertEqual(sut.state, .loaded([]))
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        sut.$state.dropFirst()
            .sink { newValue in
                switch(newValue) {
                case .loaded(_): break
                default: XCTFail("Expecting .loaded() state")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await sut.fetchRecipes()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    /// Tests the published `state` variable after fetching recipe data with empty recipes.
    func testStateEmpty() async throws {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.empty.network)
        sut = RecipeListViewModel(recipeService: mockService)
        XCTAssertEqual(sut.state, .loaded([]))
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        sut.$state.dropFirst()
            .sink { newValue in
                switch(newValue) {
                case .empty: break
                default: XCTFail("Expecting .empty state")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await sut.fetchRecipes()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    /// Tests the published `state` variable after fetching recipe data with malformed data.
    func testStateError() async throws {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.malformed.network)
        sut = RecipeListViewModel(recipeService: mockService)
        XCTAssertEqual(sut.state, .loaded([]))
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        sut.$state.dropFirst()
            .sink { newValue in
                switch(newValue) {
                case .error: break
                default: XCTFail("Expecting .error state")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await sut.fetchRecipes()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    /// Tests the `RecipeListViewModel.ModelState` message strings.
    func testModelStateMessages() throws {
        XCTAssertEqual(RecipeListViewModel.ModelState.loaded([]).message, "")
        XCTAssertEqual(RecipeListViewModel.ModelState.empty.message,
                       "No recipes are available at this time. Please check back later.")
        XCTAssertEqual(RecipeListViewModel.ModelState.error.message,
                       "Error fetching data. Pull to refresh or try again later.")
    }
}
