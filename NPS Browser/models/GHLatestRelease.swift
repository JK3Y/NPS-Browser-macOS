//
//  GHLatestRelease.swift
//  NPS Browser
//
//  Created by JK3Y on 8/17/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let gHLatestRelease = try? newJSONDecoder().decode(GHLatestRelease.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseGHLatestRelease { response in
//     if let gHLatestRelease = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct GHLatestRelease: Codable {
    let url: String
    let assetsURL: String
    let uploadURL: String
    let htmlURL: String
    let id: Int
    let nodeID: String
    let tagName: String
    let targetCommitish: String
    let name: String
    let draft: Bool
    let author: Author
    let prerelease: Bool
    let createdAt: Date
    let publishedAt: Date
    let assets: [Asset]
    let tarballURL: String
    let zipballURL: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case assetsURL = "assets_url"
        case uploadURL = "upload_url"
        case htmlURL = "html_url"
        case id = "id"
        case nodeID = "node_id"
        case tagName = "tag_name"
        case targetCommitish = "target_commitish"
        case name = "name"
        case draft = "draft"
        case author = "author"
        case prerelease = "prerelease"
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case assets = "assets"
        case tarballURL = "tarball_url"
        case zipballURL = "zipball_url"
        case body = "body"
    }
}

struct Asset: Codable {
    let url: String
    let id: Int
    let nodeID: String
    let name: String
    let label: JSONNull?
    let uploader: Author
    let contentType: String
    let state: String
    let size: Int
    let downloadCount: Int
    let createdAt: Date
    let updatedAt: Date
    let browserDownloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case id = "id"
        case nodeID = "node_id"
        case name = "name"
        case label = "label"
        case uploader = "uploader"
        case contentType = "content_type"
        case state = "state"
        case size = "size"
        case downloadCount = "download_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case browserDownloadURL = "browser_download_url"
    }
}

struct Author: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url: String
    let htmlURL: String
    let followersURL: String
    let followingURL: String
    let gistsURL: String
    let starredURL: String
    let subscriptionsURL: String
    let organizationsURL: String
    let reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url = "url"
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date"))
    })
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    encoder.dateEncodingStrategy = .formatted(formatter)
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseGHLatestRelease(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<GHLatestRelease>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
