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
        case (.error, .error), (.emptyFilter, .emptyFilter), (emptyNetwork, emptyNetwork): return lhs.message == rhs.message
        case (.loaded(let lhsRecipes), .loaded(let rhsRecipes)): return lhsRecipes == rhsRecipes
        default: return false
        }
    }
}

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    
    /// System under test.
    var sut: RecipeListViewModel!
    
    /// Tests the creation of the `RecipeListViewModel`
    func testInit() {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.valid.network)
        sut = RecipeListViewModel(recipeService: mockService)
        XCTAssertEqual(sut.state, .loaded([]))
        XCTAssertEqual(sut.filterSelection, .all)
        XCTAssertEqual(sut.sortingSelection, .alphabeticalAscending)
        XCTAssertEqual(sut.title, "Fetch Mobile")
        XCTAssertEqual(sut.filterMenuTitle, "Filter")
        XCTAssertEqual(sut.sortMenuTitle, "Sort")
    }
    
    /// Tests the array of recipes after sorting from A-Z
    func testStateLoadedSortedAtoZ() async throws {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.valid.network)
        sut = RecipeListViewModel(recipeService: mockService)
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        let sortedRecipes = try await Mocks.RecipeService.validSortedAZ.getMockRecipes()
        sut.$state.dropFirst()
            .sink { newState in
                switch(newState) {
                case .loaded(let recipes): XCTAssertEqual(recipes, sortedRecipes)
                default: XCTFail("Expecting .loaded() state")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await sut.fetchRecipes()
        await fulfillment(of: [expectation], timeout: 5)
        // now validate sorted data
    }
    
    /// Tests the array of recipes after sorting from Z-A
    func testStateLoadedSortedZtoA() async throws {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.valid.network)
        sut = RecipeListViewModel(recipeService: mockService)
        sut.sortingSelection = .alphabeticalDescending
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        let sortedRecipes = try await Mocks.RecipeService.validSortedZA.getMockRecipes()
        sut.$state.dropFirst()
            .sink { newState in
                switch(newState) {
                case .loaded(let recipes): XCTAssertEqual(recipes, sortedRecipes)
                default: XCTFail("Expecting .loaded() state")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await sut.fetchRecipes()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    /// Tests the published `state` variable after fetching recipe data with empty recipes.
    func testStateEmptyNetwork() async throws {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.empty.network)
        sut = RecipeListViewModel(recipeService: mockService)
        XCTAssertEqual(sut.state, .loaded([]))
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        sut.$state.dropFirst()
            .sink { newValue in
                switch(newValue) {
                case .emptyNetwork: break
                default: XCTFail("Expecting .emptyNetwork state")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await sut.fetchRecipes()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    /// Tests the published `state` variable after fetching recipe data but the filter results in no recipes.
    func testStateEmptyFilter() async throws {
        let mockService = RecipeService(networkComponent: Mocks.RecipeService.noAmerican.network)
        sut = RecipeListViewModel(recipeService: mockService)
        sut.filterSelection = .american
        XCTAssertEqual(sut.state, .loaded([]))
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        sut.$state.dropFirst()
            .sink { newState in
                switch(newState) {
                case .emptyFilter: break
                default: XCTFail("Expecting .emptyFilter state")
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
        let expectation = XCTestExpectation(description: "State value updated")
        var cancellables = Set<AnyCancellable>()
        sut.$state.dropFirst()
            .sink { newState in
                switch(newState) {
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
        XCTAssertEqual(RecipeListViewModel.ModelState.emptyNetwork.message,
                       "No recipes are available at this time. Please check back later.")
        XCTAssertEqual(RecipeListViewModel.ModelState.emptyFilter.message,
                       "No recipes for the current filter. Try selecting a different filter.")
        XCTAssertEqual(RecipeListViewModel.ModelState.error.message,
                       "Error fetching data. Pull to refresh or try again later.")
    }
}
