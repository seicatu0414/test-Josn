//
//  TargetURLs.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/19.
//

enum TargetURLs: String {
    case topApiURL=""
    
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Errors: Error {
    case decodingError
    case networkError(Int)
    case castError
}

