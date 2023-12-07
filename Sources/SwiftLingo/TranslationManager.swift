//
//  TranslationManager.swift
//  
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

protocol TranslationManagerProtocol {
    func openFile()
    func createNewLanguageFile()
}

final class TranslationManager: TranslationManagerProtocol {
    
    private let fileManager = FileManager.default
    private let fileReader = FileReader()

    func openFile() {
        // TODO: open local level localization file
        let localizationFilePath = "/Users/photos/Desktop/MB/Mood Bubble/Mood Bubble/Localization/en.lproj/Localizable.strings"
        
        // TODO: add what languages you need
        // let langugePath = directory.appendingPathComponent("\(langCode).lproj")
        
        do {
            if !fileManager.fileExists(atPath: localizationFilePath) {
                // file doesn't exist
            } else {
                let fileContents = try String(contentsOfFile: localizationFilePath, encoding: .utf8)
                // go through contents and create an array of files
                let dictionary = fileReader.mapOutputToReadableDictionary(input: fileContents)
                print("dictionary: ", dictionary)
            }
        } catch let error {
            print("[ERROR]: ", error)
        }
    }
    
    func createNewLanguageFile() {
        
    }
}
