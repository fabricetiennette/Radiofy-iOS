import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome! Your're logged in!")
            Text(" Home !")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
