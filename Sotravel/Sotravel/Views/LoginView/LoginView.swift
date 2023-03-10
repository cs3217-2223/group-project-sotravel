import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Image("snowman")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 356, height: 480)
                .clipped()
                .overlay(alignment: .topLeading) {
                    Group {
                        VStack(alignment: .leading, spacing: 11) {
                            VStack(alignment: .leading, spacing: 1) {

                            }
                        }
                        .padding()
                        .padding(.top, 42)
                        Image("logo-circle")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, alignment: .center)
                            .clipped()
                            .padding()
                    }
                }
                .overlay(alignment: .bottom) {
                    Group {

                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                }
                .padding()
                .padding(.top, 40)
                .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
            VStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image(systemName: "envelope.fill")
                        .imageScale(.medium)
                    Text("Continue with Gmail").font(.primary700)
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color.primary)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.clear.opacity(0.25), lineWidth: 0)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.primary.opacity(0.1)))
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image(systemName: "paperplane.fill")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.white)
                    Text("Continue with Telegram")
                        .foregroundColor(.white).font(.primary700)
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.primary)
                
                }
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
