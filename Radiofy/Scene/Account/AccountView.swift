import SwiftUI

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
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
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    .listRowBackground(Color.clear)
            }
            
            Section {
                NavigationLink {
                    NotificationSettingsView()
                } label: {
                    Text(L10n.notifications)
                }
            }
            .listRowBackground(Color.white.opacity(0.08))
            
            Section {
                Button {
                    // TODO: Terms & Conditions.
                } label: {
                    Text(L10n.termsAndConditions)
                }
                
                
                Button {
                    // TODO: Privacy settings.
                } label: {
                    Text(L10n.privacy)
                }
            } footer: {
                Text(L10n.accountSecurityFooter)
                    .padding(.top, 2)
            }
            .listRowBackground(Color.white.opacity(0.08))
            
            Section {
                Button {
                    isShowingLogoutConfirmation = true
                } label: {
                    Text(L10n.logOut)
                        .foregroundStyle(.red)
                }
            } header: {
                Text(L10n.session)
            }
            .listRowBackground(Color.white.opacity(0.08))
            
            Section {
                Button(role: .destructive) {
                    isShowingDeleteConfirmation = true
                } label: {
                    if isDeletingAccount {
                        ProgressView()
                    } else {
                        Text(L10n.deleteAccount)
                            .foregroundStyle(.red.opacity(0.75))
                    }
                }
                .disabled(isDeletingAccount)
            } header: {
                Text(L10n.accountManagement)
            }
            .listRowBackground(Color.white.opacity(0.06))
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.account)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .alert("\(L10n.logOut)?", isPresented: $isShowingLogoutConfirmation) {
            Button(L10n.cancel, role: .cancel) {}
            
            Button(L10n.logOut, role: .destructive) {
                Task {
                    await viewModel.logout()
                    onLogout()
                }
            }
        } message: {
            Text(L10n.logoutMessage)
        }
        .alert(L10n.deleteYourAccountQuestion, isPresented: $isShowingDeleteConfirmation) {
            Button(L10n.cancel, role: .cancel) {}
            
            Button(L10n.deleteAccount, role: .destructive) {
                Task {
                    await deleteAccount()
                }
            }
        } message: {
            Text(L10n.actionCannotBeUndone)
        }
        .alert(L10n.deleteAccountFailed, isPresented: Binding(
            get: { deleteAccountError != nil },
            set: { if !$0 { deleteAccountError = nil } }
        )) {
            Button(L10n.ok, role: .cancel) {}
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
                
                Text(L10n.signedIn)
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

