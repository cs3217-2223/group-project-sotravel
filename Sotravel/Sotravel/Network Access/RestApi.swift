//
//  RESTApi.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 21/3/23.
//

import Foundation
import AsyncHTTPClient
import NIOHTTP1

protocol RestApi {
    associatedtype Path: Hashable

    static var client: HTTPClient { get }
    var baseScheme: String { get }
    var baseUrl: String { get }
    var basePathPrefix: String { get }
    var pathEnumToStr: [Path: String] { get }

    func get(path: Path,
             params: [String: String]?,
             data: [String: Any]?)
    async throws -> (HTTPResponseStatus, String?)
    func post(path: Path,
              params: [String: String]?,
              data: [String: Any]?)
    async throws -> (HTTPResponseStatus, String?)
    func put(path: Path,
             params: [String: String]?,
             data: [String: Any]?)
    async throws -> (HTTPResponseStatus, String?)
    //    func delete(path: Path,
    //                params: [String: String]?,
    //                data: [String: Any]?)
    //    async throws -> (HTTPResponseStatus, String?)

    func http_request(method: HTTPMethod,
                      path: Path,
                      params: [String: String]?,
                      data: [String: Any]?)
    async throws -> (HTTPResponseStatus, String?)
}
