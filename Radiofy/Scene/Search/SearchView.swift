import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @Binding var isSearchActive: Bool

    var body: some View {
        content
            .background(Color.clear.ignoresSafeArea())
            // Placed before .searchable so the reporter sits inside its scope,
            // which is the only place \.isSearching can be read.
            .background(SearchActivityReporter(isActive: $isSearchActive))
            .searchable(text: $viewModel.query, prompt: L10n.search)
            .task(id: SearchRequest(query: viewModel.query, scope: viewModel.scope)) {
                // .task(id:) cancels and restarts its work whenever the request changes,
                // so this sleep debounces keystrokes without any timer bookkeeping.
                // A plain `try?` would swallow the cancellation and search anyway.
                do {
                    try await Task.sleep(for: .milliseconds(300))
                } catch {
                    return
                }
                await viewModel.search()
            }
    }

    /// Bundles everything a search depends on, so switching scope re-runs the
    /// request just like typing does.
    private struct SearchRequest: Equatable {
        let query: String
        let scope: SearchViewModel.Scope
    }

    private var content: some View {
        Group {
            if viewModel.scope == .podcast {
                podcastsComingSoon
            } else {
                stationResults
            }
        }
        // `.searchScopes` renders its bar in the navigation bar, which tabRoot hides,
        // so the picker lives here. safeAreaInset pins it and insets the list's
        // content, so rows scroll underneath it rather than stopping below it.
        .safeAreaInset(edge: .top, spacing: 0) {
            if isSearchActive {
                scopePicker
                .background(.black.opacity(0.8))
            }
        }
    }

    private var scopePicker: some View {
        Picker(L10n.search, selection: $viewModel.scope) {
            ForEach(SearchViewModel.Scope.allCases) { scope in
                Text(scope.title).tag(scope)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .frame(height: 44)
        .controlSize(.large)
        .padding(.horizontal, 13)
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(white: 0.24, alpha: 0.8)
        }
    }

    @ViewBuilder
    private var stationResults: some View {
        switch viewModel.state {
        case .idle:
            recentSearches

        case .loading:
            ProgressView()
                .controlSize(.large)
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded where viewModel.stations.isEmpty:
            ContentUnavailableView.search(text: viewModel.query)

        case .loaded:
            resultsList

        case .failed(let message):
            ContentUnavailableView {
                Label("Search failed", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task { await viewModel.search() }
                }
            }
        }
    }

    private var podcastsComingSoon: some View {
        ContentUnavailableView {
            Label(L10n.podcast, systemImage: "mic")
        } description: {
            Text("Searching podcasts is coming soon.")
        }
    }

    private var recentSearches: some View {
        List {
            Section("Recent Searches") {
                Text("Radio Nova")
                Text("Dîner entre amis !")
                Text("Kizomba Essentials")
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var resultsList: some View {
        List(viewModel.stations) { station in
            SearchStationRow(station: station)
                .listRowBackground(Color.black)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        SearchModule(
            radioService: PreviewRadioService(),
            isSearchActive: .constant(false)
        )
        .makeView()
    }
    .preferredColorScheme(.dark)
}
#endif
