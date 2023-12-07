import XCTest
@testable import SwiftLingo

final class SwiftLingoTests: XCTestCase {
    func testTranslationManager() {
        SwiftLingo.shared.initialize()
    }
}
