//
//  APIModel.swift
//  test-News-App
//
//  Created by 山口 航平 on 2024/03/18.
//

import Foundation

class APIModel {
    
    /// MainAPIにGetする
    func sendMainApi(offset: String = "", volume: String = "") async throws -> APIStruct {

        var urlStr = TargetURLs.topApiURL.rawValue
        if offset != "" {
            urlStr += "?offset=" + offset
        }
        if volume != "" {
            urlStr += "&volume=" + volume
        }
        guard let targetURL = URL(string: urlStr) else { throw Errors.castError }
    
        var request = URLRequest(url: targetURL)
        request.cachePolicy = .returnCacheDataElseLoad
        request.httpMethod = HttpMethod.get.rawValue

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw Errors.networkError((response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        let decoder = JSONDecoder()
        let ApiResStruct = try decoder.decode(APIStruct.self, from: data)
        return ApiResStruct
    }

}
