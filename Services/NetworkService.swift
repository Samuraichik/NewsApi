//
//  NetworkService.swift
//  OleksiyNewsAPI
//
//  Created by Oleksa-Mykhaylo Boyko on 01.04.2021.
//

import Foundation

struct QueryParameter {
    var key: String
    var value: String
    var stringRepresentation: String {
        return key + "=" + value
    }
}

class NetworkService {
    
    // MARK: - Private Properties
    
    private var articles = [Article]()
    
    // MARK: - Public Properties
    
    public static let shared = NetworkService()
    
    // MARK: - Public functions
    
    public func getArticles(params: [QueryParameter], completion: (([Article]?, Error?) -> Void )?) {
        
        var strUrl = "https://newsapi.org/v2/top-headlines?"
        var temp  = ""
        
        if params.isEmpty {
            strUrl = "https://newsapi.org/v2/top-headlines?q=world&apiKey=55d6d05137dd48efa9d69fa6e9244dfd"
        } else {
            for value in params {
                temp += "\(value.stringRepresentation)&"
            }
            strUrl += temp + "apiKey=55d6d05137dd48efa9d69fa6e9244dfd"
        }
        strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: strUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let articleResponce = try? decoder.decode(Articles.self, from: data)
                self.articles = articleResponce!.articles
                completion?(self.articles, nil)
            }
        }.resume()
    }
}
