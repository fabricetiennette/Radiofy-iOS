import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTab = .home
    @State private var searchText = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(L10n.home, systemImage: "house.fill", value: MainTab.home) {
                HomeView()
            }

            Tab(L10n.radio, systemImage: "dot.radiowaves.left.and.right", value: MainTab.radio) {
                RadioView()
            }

            Tab(L10n.podcast, systemImage: "mic.fill", value: MainTab.podcast) {
                PodcastView()
            }

            Tab(L10n.library, systemImage: "music.note.square.stack.fill", value: MainTab.library) {
                LibraryView()
            }

            Tab(value: MainTab.search, role: .search) {
                NavigationStack {
                    SearchView()
                        .navigationTitle(L10n.search)
                        .searchable(text: $searchText)
                }
            }
        }
        .tabViewBottomAccessory {
            MiniPlayerView()
        }
        .tabBarMinimizeBehavior(.onScrollDown)
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
    MainTabView()
}
