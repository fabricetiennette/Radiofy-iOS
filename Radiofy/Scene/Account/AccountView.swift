import SwiftUI

struct AccountView: View {
    @StateObject var viewModel: AccountViewModel
    let onLogout: () -> Void
    @State private var isShowingLogoutConfirmation = false
    @State private var isShowingDeleteConfirmation = false
    @State private var isDeletingAccount = false
    @State private var deleteAccountError: String?
    
    var body: some View {
        List {
            Section {
                userHeaderCard
                    .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
                    .listRowBackground(Color.clear)
            }
            
            Section {
                Button {
                    // TODO: Edit profile.
                } label: {
                    Label("Edit profile", systemImage: "person.crop.circle")
                }
                
                
                Button {
                    // TODO: Privacy settings.
                } label: {
                    Label("Privacy", systemImage: "lock")
                }
            }
            .listRowBackground(Color.white.opacity(0.08))
            
            Section {
                NavigationLink {
                    NotificationSettingsView()
                } label: {
                    Text("Notifications")
                }
            }
            .listRowBackground(Color.white.opacity(0.08))
            
            Section("Session") {
                Button {
                    isShowingLogoutConfirmation = true
                } label: {
                    Text("Log out")
                        .foregroundStyle(.red.opacity(0.82))
                }
            }
            .listRowBackground(Color.white.opacity(0.08))
            
            Section("Account management") {
                Button(role: .destructive) {
                    isShowingDeleteConfirmation = true
                } label: {
                    if isDeletingAccount {
                        ProgressView()
                    } else {
                        Text("Delete account")
                            .foregroundStyle(.red.opacity(0.75))
                    }
                }
                .disabled(isDeletingAccount)
            }
            .listRowBackground(Color.white.opacity(0.06))
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .alert("Log out?", isPresented: $isShowingLogoutConfirmation) {
            Button("Cancel", role: .cancel) {}
            
            Button("Log out", role: .destructive) {
                Task {
                    await viewModel.logout()
                    onLogout()
                }
            }
        } message: {
            Text("This will sign you out of Radiofy on this device.")
        }
        .alert("Delete your account?", isPresented: $isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            
            Button("Delete account", role: .destructive) {
                Task {
                    await deleteAccount()
                }
            }
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
    
    private var userHeaderCard: some View {
        HStack(spacing: 16) {
            AccountAvatarButton(initials: "JE") {}
                .allowsHitTesting(false)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Jean Fabrice Etiennette")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                Text("Signed in")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 0)
        }
        .padding(18)
        .background(Color.white.opacity(0.11))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
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
