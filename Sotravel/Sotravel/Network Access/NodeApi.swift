//
//  NodeApi.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation
import AsyncHTTPClient
import NIOCore
import NIOHTTP1
import NIOFoundationCompat

class NodeApi {
    private static var client = HTTPClient(eventLoopGroupProvider: .createNew)
    private static let baseScheme = "https"
    private static let baseUrl = "qa-api.sotravel.me"
    private static let basePathPrefix = "/v1"
    private static let default_timeout: Int64 = 30

    private static let pathEnumToStr: [Path: String] = [
        .telegramSignIn: "/user/telegramSignin",
        .profile: "/user/getUser",
        .event: "",
        .invite: ""
    ]

    static func get(path: Path, params: [String: String]? = nil, data: [String: Any]? = nil)
    async throws -> (HTTPResponseStatus, String?) {
        try await http_request(method: .GET, path: path, params: params)
    }

    static func post(path: Path, params: [String: String]? = nil, data: [String: Any]? = nil)
    async throws -> (HTTPResponseStatus, String?) {
        try await http_request(method: .POST, path: path, params: params, data: data)
    }

    static func put(path: Path, params: [String: String]? = nil, data: [String: Any]? = nil)
    async throws -> (HTTPResponseStatus, String?) {
        try await http_request(method: .PUT, path: path, params: params, data: data)
    }

    static func http_request(method: HTTPMethod, path: Path, params: [String: String]? = nil,
                             data: [String: Any]? = nil) async throws -> (HTTPResponseStatus, String?) {
        guard let url = constructUrl(path: path, params: params)?.absoluteString else {
            return (HTTPResponseStatus.badRequest, nil)
        }

        var request = HTTPClientRequest(url: url)
        request.method = method

        do {
            if let data = data {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                request.body = .bytes(ByteBuffer(data: jsonData))
                request.setContentTypeToJson()
            }
            // swiftlint:disable:next_line line_length
            // request.addBearerToken(token: "some token")

            let response = try await NodeApi.client.execute(request, timeout: .seconds(NodeApi.default_timeout))
            let body = String(buffer: try await response.body.collect(upTo: 1_024 * 1_024)) // 1 MB

            return (response.status, body)
        } catch {
            throw SotravelError.NetworkError("Error ocurred when running \(method) \(url)", error)
        }
    }

    private static func constructUrl(path: Path, params: [String: String]?) -> URL? {
        guard let path = NodeApi.pathEnumToStr[path] else {
            return nil
        }

        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseUrl
        components.path = basePathPrefix + path

        if let params = params {
            components.queryItems = params.map {
                URLQueryItem(name: $0, value: $1)
            }
        }

        return components.url
    }

    //    static func get(path: Path, params: [String: String]) async throws -> (HTTPResponseStatus, String?) {
    //        guard let url = constructUrl(path: path, params: params)?.absoluteString else {
    //            return (HTTPResponseStatus.badRequest, nil)
    //        }
    //
    //        let request = HTTPClientRequest(url: url)
    //        do {
    //            let response = try await NodeApi.client.execute(request, timeout: .seconds(NodeApi.default_timeout))
    //            let body = String(buffer: try await response.body.collect(upTo: 1_024 * 1_024)) // 1 MB
    //            return (response.status, body)
    //        } catch {
    //            throw SotravelError.NetworkError("Error ocurred when running GET \(url)", error)
    //        }
    //    }

    //    static func post(path: Path, params: [String: String], data: [String: Any]) async throws -> (HTTPResponseStatus, String?) {
    //        guard let url = constructUrl(path: path, params: params)?.absoluteString else {
    //            return (HTTPResponseStatus.badRequest, nil)
    //        }
    //
    //        var request = HTTPClientRequest(url: url)
    //        request.method = .POST
    //
    //        do {
    //            let jsonData = try JSONSerialization.data(withJSONObject: data)
    //            request.body = .bytes(ByteBuffer(data: jsonData))
    //
    //            let response = try await NodeApi.client.execute(request, timeout: .seconds(NodeApi.default_timeout))
    //            let body = String(buffer: try await response.body.collect(upTo: 1_024 * 1_024)) // 1 MB
    //
    //            return (response.status, body)
    //        } catch {
    //            throw SotravelError.NetworkError("Error ocurred when running POST \(url)", error)
    //        }
    //    }
}

enum Path {
    case telegramSignIn, profile, event, invite
}
