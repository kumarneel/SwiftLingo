//
//  FileReader.swift
//
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

protocol FilerReaderProtocol {
    func mapOutputToReadableDictionary(input: String) -> [String: String]
}

class FileReader: FilerReaderProtocol {
    
    // Regular expression pattern to match key-value pairs
    private let pattern = "\"([^\"]+)\"\\s*=\\s*\"([^\"]+)\";"
    
    func mapOutputToReadableDictionary(input: String) -> [String : String] {
        
        var localizationData = [String: String]()
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

            for match in matches {
                if let keyRange = Range(match.range(at: 1), in: input),
                   let valueRange = Range(match.range(at: 2), in: input) {
                    let key = String(input[keyRange])
                    let value = String(input[valueRange])
                    localizationData[key] = value
                }
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
        return localizationData
    }
}
