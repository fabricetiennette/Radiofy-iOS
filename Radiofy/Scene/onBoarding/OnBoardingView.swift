import SwiftUI

struct OnboardingView: View {

    enum Route: Hashable {
        case signUp
        case verifyEmail(String)
        case logIn
        case forgotPassword
    }

    let onAuthenticated: () -> Void

    @Environment(\.authService) private var authService
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 14) {
                        Text("R")
                            .foregroundStyle(.white)
                            .font(.custom("Argon PERSONAL", size: 70))

                        Text(L10n.onboardingOne)
                            .foregroundStyle(.white)
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center)

                        Text("\(L10n.mainTitle).")
                            .foregroundStyle(.white)
                            .font(.system(size: 30, weight: .bold))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 12)

                    Spacer()

                    VStack(spacing: 20) {
                        Button {
                            path.append(Route.signUp)
                        } label: {
                            PrimaryCapsuleButton(title: L10n.signUp)
                        }

                        Button {
                            path.append(Route.logIn)
                        } label: {
                            OutlineCapsuleButton(title: L10n.logIn.uppercased())
                        }

                        // Guest access intentionally removed.
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 70)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .signUp:
                    signUpDestination

                case .verifyEmail(let email):
                    verifyEmailDestination(email: email)

                case .logIn:
                    logInDestination

                case .forgotPassword:
                    forgotPasswordDestination
                }
            }
        }
    }

    @ViewBuilder
    private var signUpDestination: some View {
        if let authService {
            SignUpModule(
                authService: authService,
                onEmailVerificationRequired: { email in
                    // Navigate to verify email after successful registration.
                    path.append(Route.verifyEmail(email))
                },
                onAuthenticated: {
                    onAuthenticated()
                }
            )
            .makeView()
        } else {
            Text("Auth service is not available.")
        }
    }

    @ViewBuilder
    private func verifyEmailDestination(email: String) -> some View {
        if let authService {
            VerifyEmailModule(
                authService: authService,
                onAuthenticated: {
                    onAuthenticated()
                },
                email: email
            )
            .makeView()
        } else {
            Text("Auth service is not available.")
        }
    }

    @ViewBuilder
    private var logInDestination: some View {
        if let authService {
            LogInModule(
                authService: authService,
                onAuthenticated: {
                    onAuthenticated()
                },
                onBack: {
                    if !path.isEmpty { path.removeLast() }
                },
                onForgotPassword: {
                    path.append(Route.forgotPassword)
                }
            )
            .makeView()
        } else {
            Text("Auth service is not available.")
        }
    }

    @ViewBuilder
    private var forgotPasswordDestination: some View {
        if let authService {
            PasswordResetModule(authService: authService)
                .makeView()
        } else {
            Text("Auth service is not available.")
        }
    }
}

// MARK: - Buttons

private struct PrimaryCapsuleButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color(Asset.greenMain.color))
            .clipShape(Capsule())
    }
}

private struct OutlineCapsuleButton: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.black)
            .overlay(
                Capsule().stroke(Color.white.opacity(0.8), lineWidth: 1)
            )
            .clipShape(Capsule())
    }
}

#if DEBUG
#Preview {
    OnboardingView(onAuthenticated: {})
}
#endif
