//
//  ProfileTextView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/3/23.
//

import SwiftUI

struct ProfileTextView: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("John")
                .bold()
                .font(.title)
            Text("Student")
                .font(.body)
                .foregroundColor(.secondary)
        }.padding()
        Text("This free calculator is also an excellent way to improve your creative writing.")
            .multilineTextAlignment(.center)
            .padding()
        Spacer()
    }
}

struct ProfileTextView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTextView()
    }
}
