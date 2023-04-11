//
//  ViewErrorHanlder.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

import SwiftUI

class ViewErrorHandler {
    
    func handle(_ error: Error) {
        guard let sotravelError = error as? SotravelError else {
            showAlert(message: "Unknown error occurred")
            return
        }
        
        switch sotravelError {
        case .NetworkError(let message, _):
            showAlert(message: message)
        case .AuthorizationError(let message, _):
            showAlert(message: message)
        case .DecodingError(let message, _):
            showAlert(message: message)
        case .CastingError(let message, _):
            showAlert(message: message)
        case .message(let message, _):
            showAlert(message: message)
        case .generic(let error):
            showAlert(message: error.localizedDescription)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
