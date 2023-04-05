//
//  DecoderHelper.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 5/4/23.
//

import Foundation

class DecoderHelper {
    static func decodeToClass<ApiModelType: Decodable, ReturnType: ConvertableFromApiModel>(
        functionName: String,
        data: String,
        convertFrom: ApiModelType.Type)
    throws -> ReturnType {
        do {
            let responseModel = try JSONDecoder().decode(ApiModelType.self, from: Data(data.utf8))

            guard let responseModelAsApiModel = responseModel as? ReturnType.TypeToConvertFrom else {
                let modelName = String(describing: ReturnType.self)
                let apiModelName = String(describing: type(of: responseModel.self))
                throw SotravelError.CastingError("Unable to cast \(apiModelName) to \(modelName)")
            }
            return try ReturnType(apiModel: responseModelAsApiModel)
        } catch is DecodingError {
            throw SotravelError.message("Unable to decode json at \(functionName). The JSON string is \(data)")
        } catch {
            throw error
        }
    }
}
