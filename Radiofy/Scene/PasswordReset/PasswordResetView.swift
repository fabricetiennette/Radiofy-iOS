import SwiftUI

struct PasswordResetView: View {

    @StateObject var viewModel: PasswordResetViewModel

    @State private var remainingSeconds: Int = 0
    @State private var isTimerRunning: Bool = false
    @State private var isNewPasswordVisible: Bool = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Reset your password")
                    .font(.system(size: 28, weight: .bold))

                Text("Enter the email address associated with your account and we’ll send you a verification code.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)

                // Email
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                // Step 2: Code + new password
                if viewModel.step == .enterCodeAndPassword {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("6-digit code", text: $viewModel.code)
                            .keyboardType(.numberPad)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .onChange(of: viewModel.code) { _, newValue in
                                let digitsOnly = newValue.filter { $0.isNumber }
                                let limited = String(digitsOnly.prefix(6))
                                if limited != newValue {
                                    viewModel.code = limited
                                }
                            }

                        HStack(spacing: 10) {
                            Group {
                                if isNewPasswordVisible {
                                    TextField("New password", text: $viewModel.newPassword)
                                } else {
                                    SecureField("New password", text: $viewModel.newPassword)
                                }
                            }
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                            Button {
                                isNewPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isNewPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(isNewPasswordVisible ? "Hide password" : "Show password")
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        Text("Code expires in \(formattedTime(remainingSeconds)).")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(remainingSeconds > 0 ? Color.secondary : Color.red)

                        if remainingSeconds == 0 {
                            Text("Your code has expired. Please request a new one.")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Button {
                    Task {
                        switch viewModel.step {
                        case .enterEmail:
                            await viewModel.requestPasswordReset()
                        case .enterCodeAndPassword:
                            guard remainingSeconds > 0 else {
                                viewModel.setError("Verification code expired. Please request a new code.")
                                return
                            }
                            await viewModel.requestNewPassword()
                        case .done:
                            break
                        }
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color(asset: Asset.radiofyGreen))
                            .frame(height: 52)

                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text(buttonTitle)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.5 : 1.0)
                .padding(.horizontal, 12)
                .padding(.top, 12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .navigationTitle("Forgot password")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.step) { _, newStep in
            if newStep == .enterCodeAndPassword {
                startCountdownIfNeeded()
            } else {
                stopCountdown()
            }
        }
        .onReceive(timer) { _ in
            guard isTimerRunning, remainingSeconds > 0 else { return }
            remainingSeconds -= 1
            if remainingSeconds == 0 {
                stopCountdown()
            }
        }
    }

    private var buttonTitle: String {
        switch viewModel.step {
        case .enterEmail:
            return "SEND CODE"
        case .enterCodeAndPassword:
            return "SEND"
        case .done:
            return "DONE"
        }
    }

    private func startCountdownIfNeeded() {
        if remainingSeconds == 0 {
            remainingSeconds = 10 * 60
        }
        isTimerRunning = true
    }

    private func stopCountdown() {
        isTimerRunning = false
    }

    private func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

#if DEBUG
#Preview {
    let viewModel = PasswordResetViewModel(
        authService: AuthService(baseURL: AppConfig.apiBaseURL)
    )

    NavigationStack {
        PasswordResetView(viewModel: viewModel)
    }
}
#endif
