import XCTest
@testable import SwiftLingo

final class SwiftLingoTests: XCTestCase {
    func testInitialize() {
        // test path
        SwiftLingo.shared.initialize(
            directoryPath: "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local",
            desiredLanguages: ["en", "es", "fr", "de"]
        )
    }
}
