import SwiftUI

struct SearchStationRow: View {
    let station: RadioStation

    /// Music shows a chevron on rows that navigate and an ellipsis on rows that
    /// open a menu, so the accessory is the caller's decision, not the row's.
    var showsChevron: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 48, height: 48)
                .overlay {
                    if let imageUrl = station.imageUrl {
                        AsyncImage(url: imageUrl) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            placeholderIcon
                        }
                    } else {
                        placeholderIcon
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(station.name)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                }
            }

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.3))
                    .padding(.trailing, 6)
            }
            
        }
        .accessibilityElement(children: .combine)
    }

    /// The API sends empty strings rather than null for unknown country or language,
    /// so blanks are filtered out before building the subtitle.
    private var subtitle: String? {
        let parts = [station.country, station.language]
            .compactMap { $0 }
            .filter { !$0.isEmpty }

        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }

    private var placeholderIcon: some View {
        Image(systemName: "dot.radiowaves.left.and.right")
            .foregroundStyle(.white.opacity(0.9))
    }
}
