import SwiftUI

struct LibraryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text(" Library !")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#if DEBUG
#Preview {
    LibraryView()
}
#endif
