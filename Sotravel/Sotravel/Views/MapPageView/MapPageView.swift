//
//  MapPageView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 10/3/23.
//

import SwiftUI

struct MapPageView: View {
    var body: some View {
        VStack {
            MapView()
                .padding(.bottom)
        }
    }
}

struct MapPageView_Previews: PreviewProvider {
    static var previews: some View {
        MapPageView()
    }
}
