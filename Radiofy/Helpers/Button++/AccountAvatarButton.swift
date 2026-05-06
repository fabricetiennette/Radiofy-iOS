import SwiftUI

struct AccountAvatarButton: View {
    let initials: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(initials)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.30, green: 0.20, blue: 0.48),
                                    Color(red: 0.13, green: 0.30, blue: 0.36)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Account")
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        AccountAvatarButton(initials: "JE") {}
    }
}
#endif
