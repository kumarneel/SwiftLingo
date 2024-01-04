//
//  File.swift
//  
//
//  Created by Neel Kumar on 12/8/23.
//

import Foundation


class API {
    
    let openAPIKey: String
    
    init(openAPIKey: String) {
        self.openAPIKey = openAPIKey
    }

    func makeAPIRequest(
        _ primaryLanguageData: [String: String],
        _ languageCode: String,
        completion: @escaping(_ data: [String: String]) -> Void
    ){

        // Set the API endpoint URL
        let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!

        // Set the request headers
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAPIKey)", forHTTPHeaderField: "Authorization")

        // Set the request body
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo-1106",
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system",
                 "content": "You are going to localize a string array's values into different languages. Can you ONLY translate the values associated with each key. Return a json list of the same keys but now mapped to the localized values based on the primary language code and language code I want you to translate into?"],
                ["role": "user",
                 "content": "The primary language is \"en\" and I want to translate to \"\(languageCode)\". Here is the array I want to translate\n\(primaryLanguageData)"]
            ]
        ]

        // Convert the request body to JSON
        let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        var translatedData = ["":""]
        
        // Make the API request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle the response here
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // Process the response data
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = (json["choices"] as? [[String: Any]])?.first?["message"] as? [String: Any],
                           let contentDict = message["content"] as? String {
                            translatedData = try self.convertToDictionary(contentDict)
                            completion(translatedData)
                        }
                    }
                } catch {
                    completion(["":""])
                }
            }
        }

        task.resume()
    }
    
    private func convertToDictionary(_ text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
}


