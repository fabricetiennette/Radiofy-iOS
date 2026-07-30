import SwiftUI
import AuthenticationServices

struct LogInView: View {
    @StateObject var viewModel: LogInViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(L10n.logInToRadiofy)
                    .font(.system(size: 28, weight: .bold))

                // Email
                VStack(alignment: .leading, spacing: 8) {
                    TextField(L10n.email, text: $viewModel.email)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                // Password + eye toggle
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Group {
                            if viewModel.isPasswordVisible {
                                TextField(L10n.password, text: $viewModel.password)
                            } else {
                                SecureField(L10n.password, text: $viewModel.password)
                            }
                        }
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                        Button {
                            viewModel.isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(viewModel.isPasswordVisible ? L10n.hidePassword : L10n.showPassword)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    HStack {
                        Spacer()

                        Button(L10n.forgotYourPassword) {
                            viewModel.didTapPasswordReset()
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                    }
                }

                // Error
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                // Log in button
                Button {
                    Task { await viewModel.logIn() }
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color(asset: Asset.radiofyGreen))
                            .frame(height: 52)

                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text(L10n.logIn.uppercased())
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .disabled(!viewModel.canSubmit)
                .opacity(viewModel.canSubmit ? 1.0 : 0.5)
                .padding(.horizontal, 12)
                .padding(.top, 12)

                // Separator + Apple button
                VStack(spacing: 14) {
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(Color.white.opacity(0.35))
                            .frame(height: 1)

                        Text(L10n.or.uppercased())
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.75))

                        Rectangle()
                            .fill(Color.white.opacity(0.35))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 24)

                    SignInWithAppleButton(
                        .signIn,
                        onRequest: configureAppleRequest,
                        onCompletion: handleAppleCompletion
                    )
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .navigationTitle(L10n.logIn)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension LogInView {
    func configureAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        AppleSignInSupport.configure(request, mode: .signIn)
    }

    func handleAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            do {
                let payload = try AppleSignInSupport.payload(from: authorization)
                Task {
                    await viewModel.signInWithApple(
                        idToken: payload.idToken,
                        givenName: payload.givenName,
                        familyName: payload.familyName
                    )
                }
            } catch {
                viewModel.setError(L10n.appleSignInFailed)
            }

        case .failure:
            viewModel.setError(L10n.appleSignInFailed)
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = LogInViewModel(
        authService: AuthService(baseURL: AppConfig.apiBaseURL),
        onAuthenticated: {}
    )
    NavigationStack {
        LogInView(viewModel: viewModel)
    }
}
#endif
