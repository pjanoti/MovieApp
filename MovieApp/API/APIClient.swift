//
//  APIClient.swift
//  MovieApp
//
//  Created by prema janoti on 3/1/18.
//  Copyright © 2018 prema. All rights reserved.
//

import UIKit
import Foundation

let kBaseURL = "https://api.androidhive.info/json/movies.json"

// This APIClient will be called by the movieViewModel to get movie data.

class APIClient: NSObject {
  
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        guard let url = URL(string: kBaseURL) else {
            return completion(.error("Invalid URL, we can't update your feed"))
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return completion(.error(error!.localizedDescription))
            }
            guard let data = data else {
                return completion(.error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let itemsJsonArray = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]]{
                    DispatchQueue.main.async {
                        completion(.success(itemsJsonArray))
                    }
                }
            }
        }.resume()
    }
}


enum Result<T> {
    case success(T)
    case error(String)
}
