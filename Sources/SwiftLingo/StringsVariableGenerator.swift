//
//  StringsVariableGenerator.swift
//
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

protocol StringsVariableGeneratorProtocol {
    func generate()
}

final class StringsVariableGenerator: StringsVariableGeneratorProtocol {
    
    let localizationDirectoryPath: String
    let primaryLanguageData: [String: String]
    
    private let fileManager = FileManager.default

    init(localizationDirectoryPath: String, primaryLanguageData: [String: String]) {
        self.localizationDirectoryPath = localizationDirectoryPath
        self.primaryLanguageData = primaryLanguageData
    }
    
    // auto generate the localizable file
    func generate() {
        let directory = URL(fileURLWithPath: "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local/")
        let filePath = directory.appendingPathComponent("LocalizableStrings.swift")
        
        let writeText = generateNewVariablesFileString()
        
        do {
            if !fileManager.fileExists(atPath: filePath.path) {
                // throw large fatal error, file does not exist for code
                fileManager.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            }
            try writeText.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            print("[SL LOG]: successfully generated new LocalizableStrings")
        } catch let error {
            print("[SL ERROR]: ", error)
        }
    }
    
    func generateNewVariablesFileString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        
        var swiftCodeToWrite = """
        // Autogenerated at " + formatter.string(from: Date()) + ". Do not modify\n\n
        import Foundation

        struct LocalizableStrings {
        
        """
        
        for key in primaryLanguageData.keys {
            swiftCodeToWrite += "\tstatic let \(key) = NSLocalizedString(\"\(key)\", comment: \"Localizable\")\n"
        }
        
        swiftCodeToWrite += "\n}"
        
        return swiftCodeToWrite
    }
}