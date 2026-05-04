import SwiftUI

struct MiniPlayerView: View {
    var body: some View {
        HStack(spacing: 12) {
            artworkPlaceholder
                .padding(.leading)

            VStack(alignment: .leading, spacing: -2) {
                Text("Radiofy")
                    .font(.headline)
                    .lineLimit(1)

                Text("Not playing")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()
            
            HStack(spacing: 18) {
                Button {
                    // TODO: Play / Pause
                } label: {
                    Image(systemName: "play.fill")
                        .font(.title3.weight(.semibold))
                }
                .buttonStyle(.plain)
                
                Button {
                    // TODO: Next
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title3.weight(.semibold))
                }
                .buttonStyle(.plain)
            }
            .padding(.trailing, 20)
        }
        .padding(.vertical, 8)
    }

    private var artworkPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.secondary.opacity(0.18))
            .frame(width: 32, height: 32)
            .overlay {
                Image(systemName: "music.note")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
    }
}

#Preview {
    TabView {
        Tab("Home", systemImage: "house.fill") {
            Text("Home")
        }
    }
    .tabViewBottomAccessory {
        MiniPlayerView()
    }
}
