import SwiftUI

struct NotificationSettingsView: View {
    @State private var pushNotificationsEnabled = true
    @State private var newRadioNotificationsEnabled = true
    @State private var podcastNotificationsEnabled = true

    var body: some View {
        List {
            Section {
                Toggle("Push notifications", isOn: $pushNotificationsEnabled)
                Toggle("New radios", isOn: $newRadioNotificationsEnabled)
                Toggle("Podcasts", isOn: $podcastNotificationsEnabled)
            } footer: {
                Text("Choose which notifications you want to receive from Radiofy.")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Notifications")
    }
}

#if DEBUG
#Preview {
    NotificationSettingsView()
}
#endif
