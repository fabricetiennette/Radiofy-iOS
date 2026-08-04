import SwiftUI

/// Mirrors `\.isSearching` out to the host view, which lives above the
/// `.searchable` modifier and therefore cannot read it directly.
///
/// Attach it as a background *before* `.searchable`, so it sits inside that
/// modifier's scope — placed after, `isSearching` never turns true.
struct SearchActivityReporter: View {
    @Binding var isActive: Bool

    @Environment(\.isSearching) private var isSearching

    var body: some View {
        Color.clear
            .onChange(of: isSearching, initial: true) { _, searching in
                isActive = searching
            }
    }
}
