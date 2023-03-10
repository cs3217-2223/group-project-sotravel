//
//  EventView.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 9/3/23.
//

import SwiftUI

struct EventView: View {
    var body: some View {
        VStack {
            HStack(spacing: 47) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("5.30pm")
                        .font(.title3)
                        .foregroundColor(Color.black)
                    Text("Today")
                        .font(.body)
                        .foregroundColor(Color.gray)
                }.offset(x: 4, y: -7)
                VStack(spacing: 7) {
                    Text("Fish & Grill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("Railay Beach")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipped()
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                    HStack(spacing: 0) {
                        Text("12 Attending")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipped()
                            .font(.footnote)
                            .foregroundColor(.blue)
                        HStack(spacing: 0) {
                            Image("demo-sleeper")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipped()
                                .mask {
                                    Circle()
                                }
                            Image("demo-climber")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipped()
                                .mask {
                                    Circle()
                                }
                                .offset(x: -8)
                            Image("demo-snowboarder")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipped()
                                .mask {
                                    Circle()
                                }
                                .offset(x: -16)
                        }
                    }
                    .padding(.top, 1)
                }
            }
            HStack(alignment: .firstTextBaseline) {
                Text("Join")
            }
            .font(.button)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .clipped()
            .foregroundColor(Color.primary)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.clear.opacity(0.25), lineWidth: 0)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.primary.opacity(0.1)))
            }
        }
        .padding(16)
        .background(.white)
        .clipped()
        .mask { RoundedRectangle(cornerRadius: 20, style: .continuous) }
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.gray.opacity(0.3), lineWidth: 1))
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
