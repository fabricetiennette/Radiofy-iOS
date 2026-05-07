import SwiftUI

struct RadioView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text(" Radio !")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#if DEBUG
#Preview {
    RadioView()
}
#endif
