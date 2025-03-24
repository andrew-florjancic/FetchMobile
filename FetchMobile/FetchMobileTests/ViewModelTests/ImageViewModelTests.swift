//
//  ImageViewModelTests.swift
//  FetchMobileTests
//
//  Created by Andrew Florjancic on 3/23/25.
//  Copyright © 2025 Andrew Florjancic. All rights reserved.
//

import XCTest
import Combine
@testable import FetchMobile

@MainActor
final class ImageViewModelTests: XCTestCase {
    
    /// System under test.
    var sut: ImageViewModel!
    
    /// Tests the initilization of the ViewModel.
    func testInit() async throws {
        let imageService = ImageService(networkComponent: Mocks.ImageService.apamBalikImageLarge.network,
                                        cache: NSCache<NSString, UIImage>(),
                                        endpoint: Mocks.ImageService.apamBalikImageLarge.endpoint)
        sut = ImageViewModel(imageService: imageService, imageSize: 50)
        XCTAssertEqual(sut.backgroundColor, .secondary)
        XCTAssertEqual(sut.imageSize, 50)
    }
    
    /// Tests the observable image variable when updated.
    func testImageVar() async throws {
        let imageService = ImageService(networkComponent: Mocks.ImageService.apamBalikImageLarge.network,
                                        cache: NSCache<NSString, UIImage>(),
                                        endpoint: Mocks.ImageService.apamBalikImageLarge.endpoint)
        sut = ImageViewModel(imageService: imageService, imageSize: 50)
        let expectation = XCTestExpectation(description: "Image updated")
        let expectedImage = try Mocks.ImageService.apamBalikImageLarge.image(from: bundle)
        var cancellables = Set<AnyCancellable>()
        sut.$image.dropFirst()
            .sink { newImage in
                XCTAssertNotNil(newImage.pngData())
                XCTAssertEqual(newImage.pngData(), expectedImage.pngData())
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await sut.fetchImage()
        await fulfillment(of: [expectation], timeout: 5)
    }
}
