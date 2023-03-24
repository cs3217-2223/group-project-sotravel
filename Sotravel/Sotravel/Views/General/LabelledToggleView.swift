import SwiftUI

struct LabelledToggleView: View {
    var icon: String
    var title: String
    var subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .opacity(0.1)
                        .frame(width: 40, height: 40)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.uiHeadline)
                    Text(subtitle)
                        .font(.uiSubheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.frame(width: 300)

            Toggle("", isOn: $isOn)
                .padding(.trailing)
        }.padding(.bottom)
    }
}
