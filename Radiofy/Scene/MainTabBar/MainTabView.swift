import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            
            Tab("Radio", systemImage: "dot.radiowaves.left.and.right") {
                RadioView()
            }
            
            Tab("Podcast", systemImage: "mic.fill") {
                PodcastView()
            }
            
            Tab("Library", systemImage: "music.note.square.stack.fill") {
                LibraryView()
            }
            
            Tab(role: .search) {
                SearchView()
            }
        }
        .tabViewBottomAccessory {
            MiniPlayerView()
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    MainTabView()
}
