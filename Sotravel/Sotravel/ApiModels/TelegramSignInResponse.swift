//
//  TelegramSignInResponse.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 18/3/23.
//

import Foundation

struct TelegramSignInResponse: Codable, ApiModel, ConvertableFromApiModel {
    let user: NodeApiUser
    let token: String

    init(apiModel: TelegramSignInResponse) throws {
        self = apiModel
    }
}

// MARK: - User
struct NodeApiUser: Codable, ApiModel {
    let id: String
    let backupID, teleUsername, teleID: String?
    let socialsTiktok, socialsInstagram: String?
    let socialsTelegram: String?
    let socialsWhatsapp: String?
    let firstName, lastName, country, city: String?
    let gender: String?
    let phoneNumber: String?
    let email: String?
    let image: String?
    let birthday: String?
    let cfoDesc: String?
    let groupBookingID: String?
    let credits: Int?
    let interests: [String]?
    let description, createdat, updatedat: String?
    let currentlyOnTrip: String?
    let coordinator: Bool?
    let socialsLinkedin: String?

    enum CodingKeys: String, CodingKey {
        case id
        case backupID = "backup_id"
        case teleUsername = "tele_username"
        case teleID = "tele_id"
        case socialsTiktok = "socials_tiktok"
        case socialsInstagram = "socials_instagram"
        case socialsTelegram = "socials_telegram"
        case socialsWhatsapp = "socials_whatsapp"
        case firstName = "first_name"
        case lastName = "last_name"
        case country, city, gender
        case phoneNumber = "phone_number"
        case email, image, birthday
        case cfoDesc = "cfo_desc"
        case groupBookingID = "group_booking_id"
        case credits, interests, description, createdat, updatedat
        case currentlyOnTrip = "currently_on_trip"
        case coordinator
        case socialsLinkedin = "socials_linkedin"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable {
    static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        true
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self,
                                             DecodingError.Context(codingPath: decoder.codingPath,
                                                                   debugDescription: "Wrong type for JSONNull"))
        }
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
