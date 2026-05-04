import SwiftUI

struct VerifyEmailView: View {

    @StateObject var viewModel: VerifyEmailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Verify your email")
                    .font(.system(size: 28, weight: .bold))
                
                // Subtitle
                Text(infoAttributedText)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                
                
                // Code input
                OTPCodeField(code: $viewModel.code, length: 6)
                
                
                // Error / success
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Primary button
                Button {
                    Task { await viewModel.verifyEmail() }
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color(asset: Asset.radiofyGreen))
                            .frame(height: 52)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("VERIFY")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.5 : 1.0)
                .padding(.horizontal, 12)
                .padding(.top, 12)
                
                // Resend
                VStack(alignment: .center, spacing: 8) {
                    Button {
                        Task { await viewModel.resendVerificationCode() }
                    } label: {
                        Text("Resend code")
                            .font(.system(size: 14, weight: .semibold))
                            .underline()
                            .foregroundStyle(viewModel.canResend ? .primary : .secondary)
                    }
                    .buttonStyle(.plain)
                    .disabled(!viewModel.canResend)
                    
                    if viewModel.cooldownSeconds > 0 {
                        Text("You can resend in \(formattedCooldown(viewModel.cooldownSeconds))")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var infoAttributedText: AttributedString {
        var text = AttributedString("We sent a 6-digit code to \(viewModel.email). Check your junk/spam folder.")
        text.font = .system(size: 14)

        if let range = text.range(of: viewModel.email) {
            text[range].font = .system(size: 14, weight: .semibold)
        }

        return text
    }

    private func formattedCooldown(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
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
