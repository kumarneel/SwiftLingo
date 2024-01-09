//
//  TranslationManager.swift
//  
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

internal protocol TranslationManagerProtocol {
    func openFile(completion: @escaping(_ primaryLanguageData: [String: String]) -> Void)
    func createLanguageFiles(localizationData: [String: String], completion: @escaping(_ languageStringMaps: [String: String]) -> Void)
    func generateStringsVariables(primaryLanguageData: [String: String])
}

internal final class TranslationManager: TranslationManagerProtocol {
    
    private let fileManager = FileManager.default
    private let fileReader = FileReader()
        
    private let directoryPath: String
    private let primaryLanguage = "en"
    private let desiredLangaugeCodes: [String]
    private let openAPIKey: String
    private let isLegacy: Bool
    
    init(directoryPath: String, desiredLangaugeCodes: [String], openAPIKey: String, isLegacy: Bool) {
        self.directoryPath = directoryPath
        self.desiredLangaugeCodes = desiredLangaugeCodes
        self.openAPIKey = openAPIKey
        self.isLegacy = isLegacy
    }

    func openFile(completion: @escaping(_ primaryLanguageData: [String: String]) -> Void) {
        let desiredLanguage = "en"
        var pathWithDesiredLanguage = ""
        if isLegacy {
            pathWithDesiredLanguage = directoryPath + "/\(desiredLanguage).lproj/Localizable.strings"
        } else {
            pathWithDesiredLanguage = directoryPath + "/Localizable.xcstrings"
        }
        
        do {
            if !fileManager.fileExists(atPath: pathWithDesiredLanguage) {
                fatalError("[SL ERROR]: Localization File does not exist")
            } else {
                let fileContents = try String(contentsOfFile: pathWithDesiredLanguage, encoding: .utf8)
                // go through contents and create an array of files
                let dictionary = fileReader.mapOutputToReadableDictionary(isLegacy: isLegacy, input: fileContents)
                completion(dictionary)
               
            }
        } catch let error {
            print("ERROR: ", error)
        }
    }
    
    func createLanguageFiles(localizationData: [String: String], completion: @escaping(_ languageStringMaps: [String: String]) -> Void) {
        
        let tranlater = Translater(openAPIKey: openAPIKey)
        
        var fileStringMap = ["":""]
        
        for desiredLangaugeCode in desiredLangaugeCodes {
            
            // we are on the primary selected language, skip
            if desiredLangaugeCode == primaryLanguage {
                continue
            }
            // TASK: clean up
            if isLegacy {
                tranlater.generateNewLanguageFileString(primaryLanguageData: localizationData, languageCode: desiredLangaugeCode) { [weak self] fileString in
                    guard let self else { return }
                    
                    fileStringMap[desiredLangaugeCode] = fileString
                    
                    self.writeToFile(writeText: fileString, langCode: desiredLangaugeCode)
                    // Notify we are done translating
                    if fileStringMap.count == self.desiredLangaugeCodes.count {
                        completion(fileStringMap)
                    }
                }
            } else {
                tranlater.generateNewLanguageArray(primaryLanguageData: localizationData, languageCode: desiredLangaugeCode) { [weak self] localizedData in
                    guard let self else { return }
                    
                    fileStringMap[desiredLangaugeCode] = desiredLangaugeCode
                    
                    print("localized data: ", localizedData)
                    self.updateCatalogFile(langCode: desiredLangaugeCode, localizedData: localizedData)
                    // Notify we are done translating
                    if fileStringMap.count == self.desiredLangaugeCodes.count {
                        completion(fileStringMap)
                    }
                }
            }
        }
    }
    
    internal func writeToFile(writeText: String,
                             langCode: String) {
        
        // TASK: abstract this file write function
        let fileManager = FileManager.default

        let directory = URL(fileURLWithPath: directoryPath)
        let langugePath = directory.appendingPathComponent("\(langCode).lproj")
        let filePath = langugePath.appendingPathComponent("Localizable.strings")
        
        do {
            if !fileManager.fileExists(atPath: langugePath.path) {
                // throw large fatal error, file does not exist for code
                fatalError("[SL ERROR]: Langauge code [\(langCode)] not found")
            }
            try writeText.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            print("[SL LOG]: ", "wrote to file - ", langCode)
        } catch let error {
            print("[SL ERROR]: ", error)
        }
    }
    
    internal func updateCatalogFile(langCode: String, localizedData: [String: String]) {
        let fileManager = FileManager.default

        let directory = URL(fileURLWithPath: directoryPath)
        let filePath = directory.appendingPathComponent("Localizable.xcstrings")
        
        do {
            if !fileManager.fileExists(atPath: filePath.path) {
                // throw large fatal error, file does not exist for code
                fatalError("[SL ERROR]: Localization file not found")
            }
            
//            try writeText.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            print("[SL LOG]: ", "wrote to file - ", langCode)
        } catch let error {
            print("[SL ERROR]: ", error)
        }
    }
    
    internal func generateStringsVariables(primaryLanguageData: [String: String]) {
        let stringsVariableGenerator = StringsVariableGenerator(
            localizationDirectoryPath: directoryPath,
            primaryLanguageData: primaryLanguageData
        )
        stringsVariableGenerator.generate()
    }
}


/*
 Nice to haves
 - automatically find the localization setup in project
 - only localize once the user is done, and ready to deploy
 - keep marked sections
 - automcatically generate the localizable strings file
 - manually prevent swift keywords from being created (compiler will yell at you if not)
 - language not found fatal error
*/
