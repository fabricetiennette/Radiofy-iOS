import SwiftUI

struct NotificationSettingsView: View {

    @State private var newPodcastEnabled = false

    var body: some View {
        List {
            Section {
                Toggle(isOn: $newPodcastEnabled) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(L10n.newPodcast)
                        
                        Text(L10n.newPodcastDescription)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            } footer: {
                Text(L10n.notificationsFooter)
                    .padding(.top, 8)
            }
            .listRowBackground(Color.white.opacity(0.08))
        }
        .navigationTitle(L10n.notifications)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
#endif
