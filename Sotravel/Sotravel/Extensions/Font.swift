import SwiftUI

extension Font {
    static let primary = Font
        .custom("Manrope-Regular", size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize)

    static let primary500 = Font
        .custom("Manrope-Medium", size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize)

    static let primary600 = Font
        .custom("Manrope-Semibold", size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize)

    static let primary700 = Font
        .custom("Manrope-Bold", size: UIFont.preferredFont(
            forTextStyle: .body
        ).pointSize)
    
    static let largeTitle = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    static let title = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    static let title2 = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
    static let title3 = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
    static let headline = Font.custom("Manrope-Semibold", size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    static let button = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    static let body = Font.custom("Manrope-Regular", size: UIFont.preferredFont(
        forTextStyle: .body
    ).pointSize)
    static let subheadline = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    static let callout = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
    static let footnote = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    static let caption = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    static let caption2 = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .caption2).pointSize)
}

