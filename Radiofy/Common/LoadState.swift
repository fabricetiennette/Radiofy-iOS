import Foundation

/// Lifecycle of a single async operation: a fetch, a form submission, a health ping.
///
/// Replaces the `isLoading` + `errorMessage` pair so a screen can never be
/// loading and failed at the same time. View models keep exposing `isLoading`
/// and `errorMessage` as computed properties, so views read them unchanged.
enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)

    var isLoading: Bool { self == .loading }

    var errorMessage: String? {
        guard case .failed(let message) = self else { return nil }
        return message
    }
}
