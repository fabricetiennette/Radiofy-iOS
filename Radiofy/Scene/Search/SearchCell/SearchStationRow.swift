import SwiftUI

struct SearchStationRow: View {
    let station: RadioStation

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 52, height: 52)
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
        }
        .padding(.vertical, 4)
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
