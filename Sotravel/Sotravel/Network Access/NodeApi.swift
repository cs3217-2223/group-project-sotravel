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

class NodeApi {
    static var client = HTTPClient(eventLoopGroupProvider: .createNew)
    private static let baseUrl = "https://qa-api.sotravel.me/v1"
    private static let default_timeout: Int64 = 30

    private static let pathEnumToStr: [Path: String] = [
        .profile: "/user/getUser",
        .event: "",
        .invite: ""
    ]

    func get(path: Path, params: [String: String]) async -> HTTPClientResponse.Body? {
        guard let path = NodeApi.pathEnumToStr[path],
              let queryParams = NodeApi.queryStrDictToRelativePath(params: params) else {
            return nil
        }

        let request = HTTPClientRequest(url: NodeApi.baseUrl + path + queryParams)
        do {
            let response = try await NodeApi.client.execute(request, timeout: .seconds(NodeApi.default_timeout))
            return response.body
        } catch {
            return nil
        }
    }

    func post(path: Path, data: [String: Any]) async -> HTTPResponseStatus {
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

    private static func queryStrDictToRelativePath(params: [String: String]) -> String? {
        var components = URLComponents()
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        return components.url?.formatted()
    }
}

enum Path {
    case profile, event, invite
}
