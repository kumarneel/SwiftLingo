//
//  File.swift
//  
//
//  Created by Neel Kumar on 12/8/23.
//

import Foundation


class API {
    enum APIError: Error {
        case requestFailed
        case invalidResponse
    }

    static func makeAPIRequest(_ primaryLanguageData: [String: String], _ languageCode: String) -> String {

        // Set the API endpoint URL
        let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!

        // Set the request headers
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")

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
        
        // Make the API request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle the response here
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                // Process the response data
                let responseString = String(data: data, encoding: .utf8)
                print("Response: \(responseString ?? "")")
            }
        }

        task.resume()
        return ""
    }
}

