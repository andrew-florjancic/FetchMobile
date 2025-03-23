//
//  MockNetworkComponent.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation
@testable import FetchMobile

/// A NetworkComponent that returns `Data` from a mock file instead of an actual network
class MockNetworkComponent: NetworkComponent {
    
    /// The name of the file containing the mock data.
    let fileName: String
    
    /// The extension of the file containing the mock data.
    let fileExtension: FileExtension
    
    /// Creates a new `MockNetworkComponent`.
    /// - Parameter fileName: The name of the file containing the mock data.
    /// - Parameter fileExtension: The extension of the file containing the mock data.
    init(fileName: String, fileExtension: FileExtension) {
        self.fileName = fileName
        self.fileExtension = fileExtension
    }
    
    func fetchData(for request: URLRequest) async throws -> Data {
        guard let url = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: fileExtension.rawValue) else {
            throw TestingError.invalidURL
        }
        return try Data(contentsOf: url)
    }
}
