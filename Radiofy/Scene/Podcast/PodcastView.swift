import SwiftUI

struct PodcastView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text(" Podcast !")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#if DEBUG
#Preview {
    PodcastView()
}
#endif
