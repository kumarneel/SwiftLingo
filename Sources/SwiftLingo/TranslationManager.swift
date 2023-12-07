//
//  TranslationManager.swift
//  
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

protocol TranslationManagerProtocol {
    func openFile()
    func createLanguageFiles(localizationData: [String: String])
}

final class TranslationManager: TranslationManagerProtocol {
    
    private let fileManager = FileManager.default
    private let fileReader = FileReader()
    private let translater = Translater()
        
    private let localizationFilePath: String
    // TODO: Automate these variables
    private let primaryLanguage = "en"
    private let desiredLangaugeCodes = ["en", "de", "fr", "es"]
    
    init(localizationFilePath: String) {
        self.localizationFilePath = localizationFilePath
    }

    func openFile() {
        
        do {
            if !fileManager.fileExists(atPath: localizationFilePath) {
                // file doesn't exist
            } else {
                let fileContents = try String(contentsOfFile: localizationFilePath, encoding: .utf8)
                // go through contents and create an array of files
                let dictionary = fileReader.mapOutputToReadableDictionary(input: fileContents)
                createLanguageFiles(localizationData: dictionary)
                generateStringsVariables(primaryLanguageData: dictionary)
            }
        } catch let error {
            print("[ERROR]: ", error)
        }
    }
    
    func createLanguageFiles(localizationData: [String: String]) {
        // TODO: add what languages you need
        // let langugePath = directory.appendingPathComponent("\(langCode).lproj")
        
        for desiredLangaugeCode in desiredLangaugeCodes {
            
            // see if we are on the primary selected language
            if desiredLangaugeCode == primaryLanguage {
                continue
            }
            
            let writeText = translater.generateNewLanguageFileString(primaryLanguageData: localizationData, languageCode: desiredLangaugeCode)
            
            print("[CODE: \(desiredLangaugeCode)]: \n", writeText)
            writeToFile(writeText: writeText, langCode: desiredLangaugeCode)
        }
    }
    
    private func writeToFile(writeText: String,
                             langCode: String) {
        
        // TODO: abstract this file write function
        let fileManager = FileManager.default
        // TODO: automate this file
        let directory = URL(fileURLWithPath: "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local/")
        let langugePath = directory.appendingPathComponent("\(langCode).lproj")
        let filePath = langugePath.appendingPathComponent("Localizable2.strings")
        do {
            if !fileManager.fileExists(atPath: langugePath.path) {
                // throw large fatal error, file does not exist for code
                fatalError("[SL ERROR]: Langauge code [\(langCode)] not found")
            }
            try writeText.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            print("[LOG]: ", "wrote to file - ", langCode)
        } catch let error {
            print("[ERROR]: ", error)
        }
    }
    
    private func generateStringsVariables(primaryLanguageData: [String: String]) {
        let stringsVariableGenerator = StringsVariableGenerator(
            localizationDirectoryPath: "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local/",
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
 */
