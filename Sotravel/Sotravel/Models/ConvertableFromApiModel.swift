//
//  ConvertableFromApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 5/4/23.
//

import Foundation

protocol ConvertableFromApiModel {
    associatedtype TypeToConvertFrom: ApiModel
    init(apiModel: TypeToConvertFrom) throws
}
