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
        .profile: "/user/getUser",
        .event: "",
        .invite: ""
    ]

    static func get(path: Path, params: [String: String]) async throws -> String? {
        guard let url = constructUrl(path: path, params: params)?.absoluteString else {
            return nil
        }

        let request = HTTPClientRequest(url: url)
        do {
            let response = try await NodeApi.client.execute(request, timeout: .seconds(NodeApi.default_timeout))
            let body = try await response.body.collect(upTo: 1_024 * 1_024) // 1 MB
            return String(buffer: body)
        } catch {
            throw SotravelError.NetworkError("Error ocurred when running GET \(url)", error)
        }
    }

    static func post(path: Path, data: [String: Any]) async -> HTTPResponseStatus {
        guard let path = NodeApi.pathEnumToStr[path] else {
            return HTTPResponseStatus.internalServerError
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data)

            var request = HTTPClientRequest(url: NodeApi.baseUrl + path )
            request.method = .POST
            request.body = .bytes(ByteBuffer(data: jsonData))

            let response = try await NodeApi.client.execute(request, timeout: .seconds(NodeApi.default_timeout))
            return response.status
        } catch {
            return HTTPResponseStatus.internalServerError
        }

    }

    private static func constructUrl(path: Path, params: [String: String]) -> URL? {
        guard let path = NodeApi.pathEnumToStr[path] else {
            return nil
        }

        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseUrl
        components.path = "/v1" + path

        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        return components.url
    }
}

enum Path {
    case profile, event, invite
}
