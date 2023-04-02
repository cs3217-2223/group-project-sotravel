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
import SwiftUI

class NodeApi: RestApi {
    typealias Path = NodeApiPath
    internal static let client = HTTPClient(eventLoopGroupProvider: .createNew)
    internal let baseScheme = "https"
    internal let baseUrl = "api.sotravel.me"
    internal let basePathPrefix = "/v1"
    private let default_timeout: Int64 = 60
    private static let authTokenKey: String = "nodeApiBearerToken"

    internal let pathEnumToStr: [Path: String] = [
        // Login
        .telegramSignIn: "/user/telegramSignin",
        // Profile
        .profile: "/user/getUser",
        .updateProfile: "/user/updateUser",
        // Friends
        .friends: "/trip/getUsersOnTrips",
        // Trips
        .userTrips: "/trip/getUserTripsForIOS",
        // Events/Invites
        .userInvites: "/invites/getUserInvitesForTrip",
        .inviteById: "/invites/getInviteById",
        .createInvite: "/invites/createInvite",
        .updateInvite: "/invites/updateUserInvitation",
        .cancelInvite: "/invites/cancelInvitation"
    ]

    static func storeAuthToken(token: String) {
        UserDefaults.standard.set(token, forKey: authTokenKey)
    }

    func getAuthToken(token: String) -> String? {
        UserDefaults.standard.string(forKey: NodeApi.authTokenKey)
    }

    func get(path: Path, params: [String: String]? = nil, data: [String: Any]? = nil)
    async throws -> (HTTPResponseStatus, String?) {
        try await http_request(method: .GET, path: path, params: params)
    }

    func post(path: Path, params: [String: String]? = nil, data: [String: Any]? = nil)
    async throws -> (HTTPResponseStatus, String?) {
        try await http_request(method: .POST, path: path, params: params, data: data)
    }

    func put(path: Path, params: [String: String]? = nil, data: [String: Any]? = nil)
    async throws -> (HTTPResponseStatus, String?) {
        try await http_request(method: .PUT, path: path, params: params, data: data)
    }

    func http_request(method: HTTPMethod, path: Path, params: [String: String]? = nil,
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

            request.addBearerToken(token: getAuthToken(token: NodeApi.authTokenKey))

            let response = try await NodeApi.client.execute(request, timeout: .seconds(default_timeout))
            let body = String(buffer: try await response.body.collect(upTo: 1_024 * 1_024)) // 1 MB

            return (response.status, body)
        } catch {
            throw SotravelError.NetworkError("Error ocurred when running \(method) \(url)", error)
        }
    }

    // Call this upon tele login to ensure we have a bearer token
    func authorize(userData: [String: Any]) async throws {
        // Hardcoded data for now
        let data: [String: Any] = [
            "id": 99_032_634,
            "first_name": "Larry",
            "last_name": "Lee",
            "photo_url": "https://t.me/i/userpic/320/JCRcwqd9fslCnzRK0TZfezSdbhGhW80LgpboQTpPzbs.jpg",
            "username": "larrylee3107",
            "auth_date": "1678697256",
            "hash": "1beb8304831d3ff306195ecb452887c0e26638c0ba882f254f2c5b4531311a55"
        ]

        let (status, response) = try await http_request(method: .POST, path: .telegramSignIn, data: data)

        guard status == HTTPResponseStatus.ok, let response = response else {
            throw SotravelError.AuthorizationError("Unable to get bearer token", nil)
        }

        do {
            let responseModel = try JSONDecoder().decode(TelegramSignInResponse.self, from: Data(response.utf8))
            NodeApi.storeAuthToken(token: responseModel.token)
        } catch is DecodingError {
            throw SotravelError.message("Unable to decode authorization call API repsonse", nil)
        } catch {
            throw SotravelError.message("Error occurred when decoding/storing authorization token")
        }
    }

    private func constructUrl(path: Path, params: [String: String]?) -> URL? {
        guard let pathStr = pathEnumToStr[path] else {
            return nil
        }

        var components = URLComponents()
        components.scheme = baseScheme
        components.host = baseUrl
        components.path = basePathPrefix + pathStr

        if let params = params {
            components.queryItems = params.map {
                URLQueryItem(name: $0, value: $1)
            }
        }

        return components.url
    }
}

enum NodeApiPath {
    case telegramSignIn,
         profile,
         updateProfile,
         userInvites,
         createInvite,
         inviteById,
         updateInvite,
         cancelInvite,
         friends,
         userTrips
}
