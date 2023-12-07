//
//  File.swift
//  
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

final class SwiftLingo {
    static let shared = SwiftLingo()
    
    func initialize() {
        // TODO: PASS THIS IN
        let translationManager = TranslationManager(localizationFilePath: "/Users/photos/Desktop/Localization/TestLocal/TestLocal/Local/en.lproj/Localizable2.strings")
        translationManager.openFile()
    }
}
