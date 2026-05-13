import SwiftUI

struct MainTabView: View {
    let onLogout: () -> Void

    @Environment(\.authService) private var authService
    @State private var selectedTab: MainTab = .home
    @State private var searchText = ""
    @State private var isAccountPresented = false

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(L10n.home, systemImage: "house.fill", value: MainTab.home) {
                tabRoot(title: L10n.home) {
                    HomeView()
                }
            }

            Tab(L10n.radio, systemImage: "dot.radiowaves.left.and.right", value: MainTab.radio) {
                tabRoot(title: L10n.radio) {
                    if let authService  {
                        NavigationStack {
                            RadioModule(authService: authService)
                                .makeView()
                        }
                    } else {
                        Text("Auth service is not available.")
                    }
                }
            }

            Tab(L10n.podcast, systemImage: "mic.fill", value: MainTab.podcast) {
                tabRoot(title: L10n.podcast) {
                    PodcastView()
                }
            }

            Tab(L10n.library, systemImage: "music.note.square.stack.fill", value: MainTab.library) {
                tabRoot(title: L10n.library) {
                    LibraryView()
                }
            }

            Tab(value: MainTab.search, role: .search) {
                tabRoot(title: L10n.search) {
                    SearchView()
                        .searchable(text: $searchText)
                }
            }
        }
        .tabViewBottomAccessory {
            MiniPlayerView()
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .sheet(isPresented: $isAccountPresented) {
            if let authService {
                NavigationStack {
                    AccountModule(
                        authService: authService,
                        onLogout: {
                            isAccountPresented = false
                            onLogout()
                        }
                    )
                    .makeView()
                }
            } else {
                Text("Auth service is not available.")
            }
        }
    }

    private func tabRoot<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Text(title)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)

                    Spacer()

                    AccountAvatarButton(initials: "JE") {
                        isAccountPresented = true
                    }
                }
                .padding(.horizontal, 20)

                content()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

private enum MainTab: Hashable {
    case home
    case radio
    case podcast
    case library
    case search
}

#Preview {
    MainTabView(onLogout: {})
}
