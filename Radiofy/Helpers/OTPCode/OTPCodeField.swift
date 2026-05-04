import SwiftUI

struct OTPCodeField: View {

    @Binding var code: String
    let length: Int

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                ForEach(0..<length, id: \.self) { index in
                    slot(at: index)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }

            TextField("", text: Binding(
                get: { code },
                set: { code = sanitize($0) }
            ))
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($isFocused)
            .opacity(0.01)
            .frame(width: 1, height: 1)
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .onAppear {
            // Auto-focus to encourage one-time-code suggestions.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isFocused = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Verification code")
        .accessibilityHint("Enter the \(length)-digit code")
    }

    @ViewBuilder
    private func slot(at index: Int) -> some View {
        let chars = Array(code)
        let value: String = index < chars.count ? String(chars[index]) : ""
        let isActive = isFocused && index == min(chars.count, length - 1)

        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                .foregroundStyle(.primary)
                .frame(height: 24)

            Rectangle()
                .frame(height: 2)
                .foregroundStyle(isActive ? Color.primary : Color.secondary.opacity(0.35))
        }
        .frame(width: 34)
    }

    private func sanitize(_ value: String) -> String {
        let digits = value.filter { $0.isNumber }
        return String(digits.prefix(length))
    }
}

#if DEBUG
#Preview {
    let viewModel = VerifyEmailViewModel(
        authService: AuthService(baseURL: AppConfig.apiBaseURL),
        onAuthenticated: {}
    )

    NavigationStack {
        VerifyEmailView(viewModel: viewModel)
    }
}
#endif
