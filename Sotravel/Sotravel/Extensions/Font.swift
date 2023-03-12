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
    static let uiLargeTitle = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    static let uiTitle1 = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    static let uiTitle2 = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
    static let uiTitle3 = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
    static let uiHeadline = Font.custom("Manrope-Semibold", size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    static let uiButton = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    static let uiBody = Font.custom("Manrope-Regular", size: UIFont.preferredFont(
        forTextStyle: .body
    ).pointSize)
    static let uiSubheadline = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    static let uiCallout = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
    static let uiFootnote = Font.custom("Manrope-Bold", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    static let uiCaption1 = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    static let uiCaption2 = Font.custom("Manrope-Regular", size: UIFont.preferredFont(forTextStyle: .caption2).pointSize)
}

