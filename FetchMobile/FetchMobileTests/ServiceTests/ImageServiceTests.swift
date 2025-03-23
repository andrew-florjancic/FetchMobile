//
//  ImageServiceTests.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/18/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import XCTest
@testable import FetchMobile

final class ImageServiceTests: XCTestCase {
    
    /// System under test
    var sut: ImageService!

    /// Tests the ImageService using an endpoint that returns a valid image data, no image cached.
    func testUncachedImage() async throws {
        let mock = Mocks.ImageService.apamBalikImageLarge
        let mockCache = NSCache<NSString, UIImage>()
        sut = ImageService(networkComponent: mock.network, cache: mockCache, endpoint: mock.endpoint)
        XCTAssertNil(mockCache.object(forKey: mock.endpoint as NSString))
        let image = try await sut.fetchImage()
        let expectedImage = try mock.image(from: bundle)
        XCTAssertEqual(image.pngData(), expectedImage.pngData())
        XCTAssertEqual(mockCache.object(forKey: mock.endpoint as NSString)?.pngData(), expectedImage.pngData())
    }
    
    /// Tests the ImageService using an endpoint that returns a valid image data, image cached prior to fetching data.
    func testCachedImage() async throws {
        let mock = Mocks.ImageService.apamBalikImageLarge
        let mockCache = NSCache<NSString, UIImage>()
        
        // Intentionally using a different image so we can verify the service returns the cached image
        let cachedImage = try Mocks.ImageService.apamBalikImageSmall.image(from: bundle)
        
        mockCache.setObject(cachedImage, forKey: mock.endpoint as NSString)
        sut = ImageService(networkComponent: mock.network, cache: mockCache, endpoint: mock.endpoint)
        let image = try await sut.fetchImage()
        XCTAssertEqual(image.pngData(), cachedImage.pngData())
    }
    
    /// Tests the ImageService using an invalid  endpoint.
    func testInvalidEndpoint() async throws {
        let mock = Mocks.ImageService.invalidEndpoint
        let mockCache = NSCache<NSString, UIImage>()
        sut = ImageService(networkComponent: mock.network, cache: mockCache, endpoint: mock.endpoint)
        do {
            _ = try await sut.fetchImage()
            XCTFail("Expecting NSURLErrorDomain Code=-1000")
        } catch { }
    }
}
