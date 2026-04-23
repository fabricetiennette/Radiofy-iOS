import SwiftUI

struct AccountView: View {
    @StateObject var viewModel: AccountViewModel
    let onLogout: () -> Void
    @State private var isShowingDeleteConfirmation = false
    @State private var isDeletingAccount = false
    @State private var deleteAccountError: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Text(" Your're logged in!")
            
            Button {
                Task {
                    await viewModel.logout()
                    onLogout()
                }
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
                isShowingDeleteConfirmation = true
            } label: {
                if isDeletingAccount {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                } else {
                    Text("Delete user")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red.opacity(0.18))
                        .foregroundStyle(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .disabled(isDeletingAccount)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .confirmationDialog(
            "Delete your account?",
            isPresented: $isShowingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete account", role: .destructive) {
                Task {
                    await deleteAccount()
                }
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Delete account failed", isPresented: Binding(
            get: { deleteAccountError != nil },
            set: { if !$0 { deleteAccountError = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(deleteAccountError ?? "")
        }
    }
    
    private func deleteAccount() async {
        isDeletingAccount = true
        defer { isDeletingAccount = false }

        do {
            try await viewModel.deleteAccount()
            onLogout()
        } catch {
            deleteAccountError = error.localizedDescription
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = AccountViewModel(authService: AuthService(baseURL: AppConfig.apiBaseURL))
                                     
    NavigationStack {
        AccountView(viewModel: viewModel, onLogout: {})
    }
}
#endif
