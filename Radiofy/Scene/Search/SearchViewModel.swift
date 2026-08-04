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

    // MARK: - Input

    @Published var query: String = ""
    @Published var scope: Scope = .radio

    // MARK: - Output / UI state

    @Published private(set) var state: LoadState = .idle
    @Published private(set) var stations: [RadioStation] = []

    var isLoading: Bool { state.isLoading }
    var errorMessage: String? { state.errorMessage }

    // MARK: - Dependencies

    private let radioService: RadioServicing

    init(radioService: RadioServicing) {
        self.radioService = radioService
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
}
