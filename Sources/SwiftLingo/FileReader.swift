//
//  FileReader.swift
//
//
//  Created by Neel Kumar on 12/7/23.
//

import Foundation

internal protocol FilerReaderProtocol {
    func mapOutputToReadableDictionary(isLegacy: Bool, input: String) -> [String: String]
    func createWriteStringForStringCatalog(input: String, localizationData: [String: String], langCode: String) -> String
}

internal class FileReader: FilerReaderProtocol {
    
    // Regular expression pattern to match key-value pairs
    private let pattern = "\"([^\"]+)\"\\s*=\\s*\"([^\"]+)\";"
    
    func mapOutputToReadableDictionary(isLegacy: Bool, input: String) -> [String : String] {
        if isLegacy {
            return readLegacyStringDictionary(input: input)
        } else {
            return readStringCatalogDictionary(input: input)
        }
    }
    
    func readLegacyStringDictionary(input: String) -> [String: String] {
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
    
    func readStringCatalogDictionary(input: String) -> [String: String] {
        var localizationData = [String: String]()
        // TASK: clean up logic
        if let dict = convertToDictionary(text: input) {
            // outer layer
            if let stringsDict = dict["strings"] as? [String: Any] {
                // key layer
                for key in stringsDict.keys {
                    // language key layer
                    if let valueDict = stringsDict[key] as? [String: Any] {
                        // localization type layer
                        if let localizationDict = valueDict["localizations"] as? [String: Any] {
                            // primary language layer
                            if let englishTranslationDict = localizationDict["en"] as? [String: Any] {
                                // srting value unit layer
                                if let stringUnitDict = englishTranslationDict["stringUnit"] as? [String: Any] {
                                    let value = stringUnitDict["value"] as? String ?? ""
                                    localizationData[key] = value
                                }
                            }
                        }
                        if valueDict["localizations"] == nil {
                            print("[SL LOG]: Key {\(key)} missing primary language translation")
                        }
                    }
                }
            }
        }

        return localizationData
    }
    
    func createWriteStringForStringCatalog(input: String, localizationData: [String: String], langCode: String) -> String {
        
        var catalogString = ""
        
        if var catalogDictionary = convertToDictionary(text: input) {
            // outer layer
            if var stringsDict = catalogDictionary["strings"] as? [String: Any] {
                // key layer
                for key in stringsDict.keys {
                    // language key layer
                    if var valueDict = stringsDict[key] as? [String: Any] {
                        // localization type layer
                        if var localizationDict = valueDict["localizations"] as? [String: Any], let localizationDataValue = localizationData[key]  {
                            // primary language layer
                            if localizationDict[langCode] == nil {
                                localizationDict[langCode] = 
                                    ["stringUnit":
                                        [
                                            "state": "translated",
                                            "value": localizationDataValue
                                        ]
                                    ] as [String: [String: String]]
                                
                            }
                            valueDict["localizations"] = localizationDict
                        }
                        stringsDict[key] = valueDict
                    }
                }
                catalogDictionary["strings"] = stringsDict
            }
            catalogString = convertDictionaryString(catalogDictionary) ?? ""
        }
        return catalogString
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertDictionaryString(_ dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error converting dictionary to raw string: \(error.localizedDescription)")
        }
        return nil
    }

}
