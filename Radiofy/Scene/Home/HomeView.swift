import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text(" Your're logged in!")
            Button {
                // TODO: Add log out action
            } label: {
                Text("Log out")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .foregroundStyle(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            Button(role: .destructive) {
                // TODO: Add delete user action
            } label: {
                Text("Delete user")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.red.opacity(0.18))
                    .foregroundStyle(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
