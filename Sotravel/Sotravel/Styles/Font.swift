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
}
