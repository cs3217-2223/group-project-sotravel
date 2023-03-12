//
//  ColorDividerView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct ColoredDividerView: View {
    var color: Color = Color(.sRGB, white: 0.5, opacity: 1)
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 3)
            .opacity(0.3)
    }
}

struct ColorDividerView_Previews: PreviewProvider {
    static var previews: some View {
        ColoredDividerView()
    }
}
