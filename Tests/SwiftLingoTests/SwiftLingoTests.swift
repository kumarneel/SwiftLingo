import XCTest
@testable import SwiftLingo

final class SwiftLingoTests: XCTestCase {
    func testInitialize() {
        SwiftLingo.shared.initialize()
    }
}
