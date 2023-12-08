//
//  File.swift
//  
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

public final class SL {
    static let shared = SL()
    
    func initialize(directoryPath: String, desiredLanguages: [String]) {
        let translationManager = TranslationManager(
            directoryPath: directoryPath,
            desiredLangaugeCodes: desiredLanguages
        )
        
        translationManager.openFile { primaryLanguageData in
            translationManager.generateStringsVariables(primaryLanguageData: primaryLanguageData)
            translationManager.createLanguageFiles(localizationData: primaryLanguageData) { languageStringMaps in
                print("[SL LOG] Localization complete")
            }
        }
    }
    
    // TODO: Automatically get the project path, just look for the correct folder
    // https://chat.openai.com/share/4a0e6d97-932e-433e-8dad-20e9a59984c8
}