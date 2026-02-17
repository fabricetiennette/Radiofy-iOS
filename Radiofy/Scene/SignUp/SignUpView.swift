import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Create a Radiofy ID")
                    .font(.system(size: 28, weight: .bold))

                // Email
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
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
                                TextField("Password", text: $viewModel.password)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                            }
                        }
                        .textContentType(.newPassword)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                        Button {
                            viewModel.isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(viewModel.isPasswordVisible ? "Hide password" : "Show password")
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    Text(viewModel.passwordRequirementsText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                // Error
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                // Sign up button (same capsule look as onboarding)
                Button {
                    Task { await viewModel.signUp() }
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color(asset: Asset.radiofyGreen))
                            .frame(height: 52)

                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("SIGN UP")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .disabled(!viewModel.canSubmit)
                .opacity(viewModel.canSubmit ? 1.0 : 0.5)
                .padding(.horizontal, 12)
                .padding(.top, 12)

                Text(privacyPolicyAttributedText)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .environment(\.openURL, OpenURLAction { url in
                        if url.scheme == "radiofy", url.host == "privacy-policy" {
                            viewModel.isPrivacyPolicyPresented = true
                            return .handled
                        }
                        return .systemAction
                    })
                    .padding(.horizontal, 24)

                // Separator + Apple button at the bottom
                VStack(spacing: 14) {
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(Color.white.opacity(0.35))
                            .frame(height: 1)

                        Text("OR")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.75))

                        Rectangle()
                            .fill(Color.white.opacity(0.35))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 24)

                    SignInWithAppleButton(
                        .signUp,
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
        .sheet(isPresented: $viewModel.isPrivacyPolicyPresented) {
            NavigationStack {
                PrivacyPolicyView()
            }
        }
        .navigationTitle("Sign up")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var privacyPolicyAttributedText: AttributedString {
        var text = AttributedString("By signing up, you confirm that you have read and accept the Privacy Policy.")

        if let range = text.range(of: "Privacy Policy") {
            text[range].link = URL(string: "radiofy://privacy-policy")
            text[range].underlineStyle = .single
            text[range].foregroundColor = .primary
            text[range].font = .system(size: 14, weight: .semibold)
        }

        return text
    }
}

private extension SignUpView {
    func configureAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        // Requesting .fullName and .email is useful on first authorization only.
        request.requestedScopes = [.fullName, .email]
    }

    func handleAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                viewModel.errorMessage = "Apple credential is missing."
                return
            }

            let idTokenString = credential.identityToken.flatMap { String(data: $0, encoding: .utf8) }
            guard let idTokenString else {
                viewModel.errorMessage = "Apple identity token is missing."
                return
            }

            let givenName = credential.fullName?.givenName
            let familyName = credential.fullName?.familyName

            Task {
                await viewModel.signInWithApple(idToken: idTokenString, givenName: givenName, familyName: familyName)
            }

        case .failure:
            viewModel.errorMessage = "Apple sign in failed."
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = SignUpViewModel(authService: AuthService(baseURL: AppConfig.apiBaseURL),
                                    onEmailVerificationRequired: { _ in },
                                    onAuthenticated: {})
    NavigationStack {
        SignUpView(viewModel: viewModel)
    }
}
#endif
