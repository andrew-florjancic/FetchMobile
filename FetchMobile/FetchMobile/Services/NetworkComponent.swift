//
//  NetworkComponent.swift
//  FetchMobile
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation

/// A protocol for fetching data from a network
protocol NetworkComponent {
    /// Downloads the contents of a URL based on the specified URL request and delivers the data asynchronously.
    /// - Parameter request: A URL request object that provides request-specific information such as the URL, cache policy, request type, and body data or body stream
    /// - Returns: An asynchronously-delivered Data instance.
    func fetchData(for request: URLRequest) async throws -> Data
}

/// The network component to be used in the `production` version of this application which just uses `URLSession.shared.data`
class ProdNetworkComponent: NetworkComponent {
    func fetchData(for request: URLRequest) async throws -> Data {
        try await URLSession.shared.data(for: request).0
    }
}
