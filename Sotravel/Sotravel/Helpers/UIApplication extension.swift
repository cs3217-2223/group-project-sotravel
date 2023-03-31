//
//  UIApplication extension.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 31/3/23.
//

import SwiftUI

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(TapGesture().onEnded(dismissKeyboard))
    }

    private func dismissKeyboard() {
        UIApplication.shared.dismissKeyboard()
    }
}
