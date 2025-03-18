//
//  MockNetworkComponent.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation
@testable import FetchMobile

/// A NetworkComponent that returns `Data` from a JSON file instead of an actual network
class MockNetworkComponent: NetworkComponent {
    
    /// The name of the file containing the mock JSON data.
    let fileName: String
    
    /// Creates a new `MockNetworkComponent`.
    /// - Parameter fileName: The name of the file containing the mock JSON data.
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func fetchData(for request: URLRequest) async throws -> Data {
        let url = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json")
        let data = try Data(contentsOf: url!)
        return data
    }
}
