import XCTest
@testable import SwiftLingo

final class SwiftLingoTests: XCTestCase {
    func testInitialize() {
        SwiftLingo.shared.initialize(
            directoryPath: "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local",
            desiredLanguages: ["en", "es", "fr", "de"]
        )
    }
}
