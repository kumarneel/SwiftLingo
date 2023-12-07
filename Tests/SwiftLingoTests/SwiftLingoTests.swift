import XCTest
@testable import SwiftLingo

final class SwiftLingoTests: XCTestCase {
    func testTranslationManager() {
        let translationManger = TranslationManager()
        translationManger.openFile()
    }
}
