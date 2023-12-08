//
//  File.swift
//  
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

public final class SwiftLingo {
    static let shared = SwiftLingo()
    
    func initialize(directoryPath: String, desiredLanguages: [String]) {
        let translationManager = TranslationManager(directoryPath: directoryPath)
        translationManager.openFile()
    }
    
    // TODO: Automatically get the project path, just look for the correct folder
    // https://chat.openai.com/share/4a0e6d97-932e-433e-8dad-20e9a59984c8
}
