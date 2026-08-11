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
            .task {
                await viewModel.loadRecentStations()
            }
            .task(id: SearchRequest(query: viewModel.query, scope: viewModel.scope)) {
                // .task(id:) cancels and restarts its work whenever the request changes,
                // so this sleep debounces keystrokes without any timer bookkeeping.
                // A plain `try?` would swallow the cancellation and search anyway.
                do {
                    try await Task.sleep(for: .milliseconds(300))
                } catch {
                    return
                }

                // Both answer the same keystroke, so they go out together rather
                // than the suggestions waiting on the results.
                async let suggestions: Void = viewModel.loadSuggestions()
                async let stations: Void = viewModel.search()
                _ = await (suggestions, stations)
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

    @ViewBuilder
    private var recentSearches: some View {
        if viewModel.recentStations.isEmpty {
            ContentUnavailableView(
                "Search stations",
                systemImage: "magnifyingglass",
                description: Text("Find stations by name, country or genre.")
            )
        } else {
            List {
                HStack {
                    Text("Recently Searched")
                        .font(.body)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)

                    Spacer()

                    Button("Clear") {
                        Task { await viewModel.clearRecentStations() }
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(asset: Asset.radiofyGreen))
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden, edges: .top)
                .padding(.top, 15)
                .alignmentGuide(.listRowSeparatorTrailing) { d in d[.trailing] + 20 }
                .frame(minHeight: 40)

                ForEach(viewModel.recentStations) { station in
                    SearchStationRow(station: station, showsChevron: true)
                        .alignmentGuide(.listRowSeparatorTrailing) { d in d[.trailing] + 20 }
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    private var resultsList: some View {
        // Read once, outside the alignment closures: those are @Sendable and cannot
        // reach into a main-actor view model, but they can capture a plain Int.
        let lastSuggestion = viewModel.suggestions.count - 1

        return List {
            // Above the results rather than instead of them: `.searchSuggestions`
            // replaces the content, which hid the very results being searched for.
            ForEach(Array(viewModel.suggestions.enumerated()), id: \.element) { index, suggestion in
                Button {
                    viewModel.query = suggestion
                } label: {
                    SuggestionRow(suggestion: suggestion, query: viewModel.query)
                }
                .buttonStyle(.plain)
                .alignmentGuide(.listRowSeparatorTrailing) { d in d[.trailing] + 20 }
                // The last suggestion's rule runs full width, marking the boundary
                // between the suggestions and the results below.
                .alignmentGuide(.listRowSeparatorLeading) { d in
                    index == lastSuggestion ? d[.leading] : d[.leading] + 26
                }
                // A suggestion is one line of text; the default row insets give it
                // as much room as a station row with its artwork. The first one gets
                // more headroom, sitting right under the scope picker.
                .listRowInsets(EdgeInsets(
                    top: index == 0 ? 18 : 6,
                    leading: 14,
                    bottom: 6,
                    trailing: 20
                ))
                // In this list the line between two rows is the lower one's top
                // separator, so only the very first row's may be hidden.
                .listRowSeparator(index == 0 ? .hidden : .automatic, edges: .top)
                .listRowBackground(Color.black)
            }

            ForEach(Array(viewModel.stations.enumerated()), id: \.element.id) { index, station in
                Button {
                    // Opening is only recorded for now; playback lands with the player.
                    Task { await viewModel.openStation(station) }
                } label: {
                    SearchStationRow(station: station)
                }
                .buttonStyle(.plain)
                .alignmentGuide(.listRowSeparatorTrailing) { d in d[.trailing] + 20 }
                // Only the top of the list, so this applies when no suggestion
                // precedes the results.
                .listRowSeparator(
                    index == 0 && viewModel.suggestions.isEmpty ? .hidden : .automatic,
                    edges: .top
                )
                .listRowBackground(Color.black)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Reusable Components

private struct SuggestionRow: View {
    let suggestion: String
    let query: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.body)
                .foregroundStyle(.white)
                .fontWeight(.semibold)

            Text(highlighted)
                .lineLimit(1)

            Spacer()
        }
        .frame(minHeight: 30)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(suggestion)
    }

    /// What the user already typed stays solid and the completion is dimmed, so
    /// the eye lands on the part that is new — the treatment Music uses.
    private var highlighted: AttributedString {
        var attributed = AttributedString(suggestion)
        attributed.foregroundColor = .white.opacity(0.55)

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedQuery.isEmpty,
           let match = attributed.range(of: trimmedQuery, options: [.caseInsensitive]) {
            attributed[match].foregroundColor = .white
        }

        return attributed
    }
}

#if DEBUG
/// Builds the view model directly rather than through the module, so a preview can
/// start with a query already typed — the only way to reach the results and the
/// suggestions, which the view model fills itself and does not expose for writing.
@MainActor
private func previewSearch(
    recents: [RadioStation] = [],
    query: String = "",
    isSearching: Bool = false
) -> some View {
    let viewModel = SearchViewModel(
        radioService: PreviewRadioService(),
        stationRepository: PreviewStationRepository(recents: recents)
    )
    viewModel.query = query

    return NavigationStack {
        SearchView(viewModel: viewModel, isSearchActive: .constant(isSearching))
    }
    .preferredColorScheme(.dark)
}

#Preview("Suggestions") {
    previewSearch(query: "nova", isSearching: true)
}

#Preview("Recents") {
    previewSearch(recents: Array(PreviewRadioService.sampleStations.prefix(3)))
}

#Preview("No recents") {
    previewSearch()
}
#endif
