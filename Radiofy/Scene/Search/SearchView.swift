import SwiftUI

struct SearchView: View {
    var body: some View {
        List {
            Section("Recently Searched") {
                Text("Radio Nova")
                Text("Dîner entre amis !")
                Text("Kizomba Essentials")
            }
        }
    }
}

#if DEBUG
#Preview {
    SearchView()
}
#endif

