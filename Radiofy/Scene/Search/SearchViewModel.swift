//
//  SearchViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 18/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {

    /// What the query is searched against. Podcast search has no endpoint yet,
    /// so that scope shows a placeholder instead of calling the API.
    enum Scope: String, CaseIterable, Identifiable {
        case radio
        case podcast

        var id: String { rawValue }

        var title: String {
            switch self {
            case .radio: return L10n.radio
            case .podcast: return L10n.podcast
            }
        }
    }

    /// Stations requested per search.
    private static let resultsLimit = 30
    /// Stations kept on device to feed the recents list and the suggestions.
    private static let recentStationsLimit = 10
    /// Suggestions offered under the search field while typing.
    private static let suggestionsLimit = 3

    // MARK: - Input

    @Published var query: String = ""
    @Published var scope: Scope = .radio

    // MARK: - Output / UI state

    @Published private(set) var state: LoadState = .idle
    @Published private(set) var stations: [RadioStation] = []
    @Published private(set) var recentStations: [RadioStation] = []

    var isLoading: Bool { state.isLoading }
    var errorMessage: String? { state.errorMessage }

    /// Interim completions drawn from the stations already opened. Swap this for
    /// the backend suggest endpoint when it exists; nothing else has to change.
    var suggestions: [String] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }

        return recentStations
            .map(\.name)
            .filter {
                $0.localizedCaseInsensitiveContains(trimmedQuery)
                && $0.localizedCaseInsensitiveCompare(trimmedQuery) != .orderedSame
            }
            .prefix(Self.suggestionsLimit)
            .map { $0 }
    }

    // MARK: - Dependencies

    private let radioService: RadioServicing
    private let stationRepository: StationRepositing

    init(radioService: RadioServicing, stationRepository: StationRepositing) {
        self.radioService = radioService
        self.stationRepository = stationRepository
    }

    // MARK: - Actions

    func search() async {
        // Nothing to call for podcasts yet; the view renders a placeholder for that scope.
        guard scope == .radio else {
            stations = []
            state = .idle
            return
        }

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        // An empty field returns to the resting state rather than showing "no results".
        guard !trimmedQuery.isEmpty else {
            stations = []
            state = .idle
            return
        }

        state = .loading

        do {
            stations = try await radioService.searchStations(
                query: trimmedQuery,
                limit: Self.resultsLimit,
                offset: 0
            )
            state = .loaded
        } catch {
            stations = []
            state = .failed(error.localizedDescription)
        }
    }

    // MARK: - Recents

    func loadRecentStations() async {
        recentStations = (try? await stationRepository.recentStations(limit: Self.recentStationsLimit)) ?? []
    }

    /// Called when a station is opened from the results. Recording the opened
    /// station rather than the typed query keeps only what actually led
    /// somewhere, instead of every abandoned keystroke.
    func openStation(_ station: RadioStation) async {
        try? await stationRepository.markOpened(station)
        await loadRecentStations()
    }

    func clearRecentStations() async {
        try? await stationRepository.clearRecentStations()
        await loadRecentStations()
    }
}
