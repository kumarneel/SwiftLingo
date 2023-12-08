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
    private let translater = Translater()
        
    private let directoryPath: String
    // TODO: Automate these variables
    private let primaryLanguage = "en"
    private let desiredLangaugeCodes: [String]
    
    init(directoryPath: String, desiredLangaugeCodes: [String]) {
        self.directoryPath = directoryPath
        self.desiredLangaugeCodes = desiredLangaugeCodes
    }

    func openFile(completion: @escaping(_ primaryLanguageData: [String: String]) -> Void) {
        let desiredLanguage = "en"
        let pathWithDesiredLanguage = directoryPath + "/\(desiredLanguage).lproj/Localizable.strings"
        
        do {
            if !fileManager.fileExists(atPath: pathWithDesiredLanguage) {
                fatalError("[SL ERROR]: Localization File does not exist")
            } else {
                let fileContents = try String(contentsOfFile: pathWithDesiredLanguage, encoding: .utf8)
                // go through contents and create an array of files
                let dictionary = fileReader.mapOutputToReadableDictionary(input: fileContents)
                completion(dictionary)
               
            }
        } catch let error {
            print("ERROR: ", error)
        }
    }
    
    func createLanguageFiles(localizationData: [String: String], completion: @escaping(_ languageStringMaps: [String: String]) -> Void) {
        
        var fileStringMap = ["":""]
        for desiredLangaugeCode in desiredLangaugeCodes {
            
            // we are on the primary selected language, skip
            if desiredLangaugeCode == primaryLanguage {
                continue
            }
            print("language code: ", desiredLangaugeCodes)
            translater.generateNewLanguageFileString(primaryLanguageData: localizationData, languageCode: desiredLangaugeCode) { fileString in
                fileStringMap[desiredLangaugeCode] = fileString
                self.writeToFile(writeText: fileString, langCode: desiredLangaugeCode)
                if fileStringMap.count == self.desiredLangaugeCodes.count {
                    completion(fileStringMap)
                }
            }
        }
    }
    
    internal func writeToFile(writeText: String,
                             langCode: String) {
        
        // TODO: abstract this file write function
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
