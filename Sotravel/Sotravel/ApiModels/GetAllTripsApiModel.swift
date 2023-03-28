//
//  GetAllTripsApiModel.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 28/3/23.
//

import Foundation

// MARK: - Welcome
struct GetAllTripsApiModel: Codable {
    let upcomingTrips, pastTrips: [TripApiModel]
}

// MARK: - Trip
struct TripApiModel: Codable {
    let id: Int
    let name, location, meetingPoint: String
    let mainImages: [String]
    let about, skillLevel: String
    let telegramGroupURL, telegramGroupURLConfirm: String
    let duration: String
    let price: Int
    let cost: Double?
    let category, currency, targetCity, targetCountry: String
    let startDate, endDate, startTime, endTime: String
    let ageRestriction: String
    let genderRestriction: String?
    let totalSlots, filledSlots, filledSlotsPaid: Int
    let paymentsOpen, tripFull: Bool
    let paymentPositionWindow: String
    let includesHeaders: [String]
    let includesImages: [String]
    let includesDescriptions, itineraryHeaders, itineraryDescriptions: [String]
    let itineraryImages, threeUserImages: [String]
    let extras, partner: String?
    let cfo, hostType: String
    let publicPaymentsOpen: Bool
    let createdat, updatedat: String
    let hidden: Bool
    let itineraryNotionDatabaseID: String
    let socialsTiktok, socialsInstagram, socialsTelegram, socialsWhatsapp: JSONNull?
    let firstName, cfoDesc: String

    enum CodingKeys: String, CodingKey {
        case id, name, location
        case meetingPoint = "meeting_point"
        case mainImages = "main_images"
        case about
        case skillLevel = "skill_level"
        case telegramGroupURL = "telegram_group_url"
        case telegramGroupURLConfirm = "telegram_group_url_confirm"
        case duration, price, cost, category, currency
        case targetCity = "target_city"
        case targetCountry = "target_country"
        case startDate = "start_date"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case ageRestriction = "age_restriction"
        case genderRestriction = "gender_restriction"
        case totalSlots = "total_slots"
        case filledSlots = "filled_slots"
        case filledSlotsPaid = "filled_slots_paid"
        case paymentsOpen = "payments_open"
        case tripFull = "trip_full"
        case paymentPositionWindow = "payment_position_window"
        case includesHeaders = "includes_headers"
        case includesImages = "includes_images"
        case includesDescriptions = "includes_descriptions"
        case itineraryHeaders = "itinerary_headers"
        case itineraryDescriptions = "itinerary_descriptions"
        case itineraryImages = "itinerary_images"
        case threeUserImages = "three_user_images"
        case extras, partner, cfo
        case hostType = "host_type"
        case publicPaymentsOpen = "public_payments_open"
        case createdat, updatedat, hidden
        case itineraryNotionDatabaseID = "itinerary_notion_database_id"
        case socialsTiktok = "socials_tiktok"
        case socialsInstagram = "socials_instagram"
        case socialsTelegram = "socials_telegram"
        case socialsWhatsapp = "socials_whatsapp"
        case firstName = "first_name"
        case cfoDesc = "cfo_desc"
    }
}
