import SwiftUI

struct FriendProfilePageView: View {
    @EnvironmentObject private var userService: UserService
    let friend: User?

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ProfileImageView(imageSrc: friend?.imageURL, name: friend?.name ?? "John Doe", width: 150, height: 150)
                Text(friend?.name ?? "John Doe")
                    .font(.uiTitle2)
                    .fontWeight(.bold)
                Text(friend?.desc ?? "")
                    .font(.uiHeadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                if let friend = friend {
                    SocialMediaLinksView(viewModel: userService.createFriendsSocialMediaLinkVM(for: friend))
                } else {
                    SocialMediaLinksView(viewModel: SocialMediaLinksViewModel())
                }
                Divider().padding(.bottom, 20)
                if let user = friend {
                    RecentActivityView(user: user)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct FriendProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FriendProfilePageView(friend: mockUser2).environmentObject(EventsStore(events: mockEvents))
        }
    }
}
