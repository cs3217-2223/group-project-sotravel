import SwiftUI

struct FriendProfilePageView: View {
    let friend: User

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ProfileImageView(imageSrc: friend.imageURL, name: friend.name, width: 150, height: 150)
                Text(friend.name)
                    .font(.uiTitle2)
                    .fontWeight(.bold)
                Text(friend.description ?? "")
                    .font(.uiHeadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                SocialMediaLinksView()
                Divider().padding(.bottom, 20)
                RecentActivityView(user: friend)
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct FriendProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FriendProfilePageView(friend: mockUser2).environmentObject(EventsStore(events: mockEvents))
        }
    }
}
