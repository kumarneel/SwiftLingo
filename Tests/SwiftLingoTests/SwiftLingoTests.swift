import XCTest
@testable import SwiftLingo

final class SwiftLingoTests: XCTestCase {
    
    private let desiredLangaugeCodes = ["en", "de", "es", "fr"]
    
    func testInitialize() {
        let directoryPath: String = "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local"
        let translationManager = TranslationManager(
            directoryPath: directoryPath,
            desiredLangaugeCodes: desiredLangaugeCodes,
            openAPIKey: "",
            isLegacy: true
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
    
    func testCatalogReader() {
        let directoryPath = "/Users/photos/Desktop/RE/TestCatalogs/TestCatalogs/Localization"
        let translationManager = TranslationManager(
            directoryPath: directoryPath,
            desiredLangaugeCodes: desiredLangaugeCodes,
            openAPIKey: "",
            isLegacy: false
        )
        let expectation = XCTestExpectation()
        
        translationManager.openFile { primaryLanguageData in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testCatalogWriter() {
        let directoryPath = "/Users/photos/Desktop/RE/TestCatalogs/TestCatalogs/Localization"
        let translationManager = TranslationManager(
            directoryPath: directoryPath,
            desiredLangaugeCodes: desiredLangaugeCodes,
            openAPIKey: "",
            isLegacy: false
        )
        let expectation = XCTestExpectation()
        
        translationManager.openFile { primaryLanguageData in
            translationManager.generateStringsVariables(primaryLanguageData: primaryLanguageData)
            translationManager.createLanguageFiles(localizationData: primaryLanguageData) { languageStringMaps in
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
        
    }
}
