//
//  Utilities.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import Foundation
import XCTest

// MARK: Testing Errors
enum TestingError: Error {
    case invalidURL
    case invalidImage
}

// MARK: File Extensions
enum FileExtension: String {
    case json
    case jpg
}

// MARK: XCTestCase extension
extension XCTestCase {
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
}
