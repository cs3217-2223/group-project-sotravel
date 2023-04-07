//
//  DecoderHelper.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 5/4/23.
//

import Foundation

class DecoderHelper {
    static func decodeToClass<ReturnType: ConvertableFromApiModel>(
        data: String, location: String = #function, line: Int = #line)
    throws -> ReturnType {
        do {
            let responseModel = try JSONDecoder().decode(ReturnType.TypeToConvertFrom.self, from: Data(data.utf8))
            return try ReturnType(apiModel: responseModel)
        } catch is DecodingError {
            let modelName = String(describing: ReturnType.self)
            let prefix = constructErrorPrefix(location: location, line: line)
            throw SotravelError.message(
                "\(prefix) Unable to decode json at \(location) to \(modelName). The JSON string is \(data)")
        } catch {
            throw error
        }
    }

    static func decodeToClassArray<ReturnType: ConvertableFromApiModel>(
        data: String, location: String = #function, line: Int = #line)
    throws -> [ReturnType] {
        do {
            let responseModel = try JSONDecoder().decode([ReturnType.TypeToConvertFrom].self, from: Data(data.utf8))
            return try responseModel.map { try ReturnType(apiModel: $0) }
        } catch is DecodingError {
            let modelName = String(describing: ReturnType.self)
            let prefix = constructErrorPrefix(location: location, line: line)
            throw SotravelError.message(
                "\(prefix) Unable to decode json at \(location) to \(modelName). The JSON string is \(data)")
        } catch {
            throw error
        }
    }

    private static func constructErrorPrefix(location: String, line: Int) -> String {
        "[Line \(line) @ \(location)]:"
    }
}
