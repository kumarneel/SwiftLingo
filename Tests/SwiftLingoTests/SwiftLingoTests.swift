import XCTest
@testable import SwiftLingo

final class SwiftLingoTests: XCTestCase {
    
    private let directoryPath: String = "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local"
    private let desiredLangaugeCodes = ["en", "de", "es", "fr"]
    
    func testInitialize() {
        let translationManager = TranslationManager(
            directoryPath: directoryPath,
            desiredLangaugeCodes: desiredLangaugeCodes
        )
        
        let expectation = XCTestExpectation()
        
        translationManager.openFile { primaryLanguageData in
            translationManager.generateStringsVariables(primaryLanguageData: primaryLanguageData)
            
            
            translationManager.createLanguageFiles(localizationData: primaryLanguageData) { languageStringMaps in
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 30)
    }
}
