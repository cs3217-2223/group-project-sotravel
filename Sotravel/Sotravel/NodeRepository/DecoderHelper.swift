//
//  DecoderHelper.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 5/4/23.
//

import Foundation

class DecoderHelper {
    static func decodeToClass<ReturnType: ConvertableFromApiModel>(
        functionName: String,
        data: String)
    throws -> ReturnType {
        do {
            let responseModel = try JSONDecoder().decode(ReturnType.TypeToConvertFrom.self, from: Data(data.utf8))
            return try ReturnType(apiModel: responseModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to decode json at \(functionName). The JSON string is \(data)")
        } catch {
            throw error
        }
    }

    static func decodeToClassArray<ReturnType: ConvertableFromApiModel>(
        functionName: String,
        data: String)
    throws -> [ReturnType] {
        do {
            let responseModel = try JSONDecoder().decode([ReturnType.TypeToConvertFrom].self, from: Data(data.utf8))
            return try responseModel.map { try ReturnType(apiModel: $0) }
        } catch is DecodingError {
            throw SotravelError.message("Unable to decode json at \(functionName). The JSON string is \(data)")
        } catch {
            throw error
        }
    }
}
