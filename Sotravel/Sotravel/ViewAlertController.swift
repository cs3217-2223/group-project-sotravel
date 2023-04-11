//
//  ViewErrorHanlder.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

import SwiftUI

class ViewAlertController: ObservableObject {
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
