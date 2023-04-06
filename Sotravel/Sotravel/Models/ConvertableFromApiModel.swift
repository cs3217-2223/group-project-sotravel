//
//  ConvertableFromApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 5/4/23.
//

import Foundation

// This protocol describes a class (typically a Model class) that can
// be created from an ApiModel. For example, a User class can be created
// from a NodeApiModel.
protocol ConvertableFromApiModel {
    // The `TypeToConvertFrom` is the Swift representation of a JSON object
    // returned from an API.
    // We use the an associatedType instead of the `ApiModel` type directly
    // to allow for compile-time type checking.
    // The associatedType's concrete type is defined by the implementing class
    // which dictates which type it is able to convert from. For example,
    // the User class would set `TypeToConvertFrom` to `NodeApiUser`
    // This ensures that a class that implements this protocol can implement
    // an initializer that takes in the _specific type_ it is able to convert
    // from, preventing the issue of, for example, a TripApiResponse being passed
    // in to a User initializer.
    associatedtype TypeToConvertFrom: ApiModel
    init(apiModel: TypeToConvertFrom) throws
}
