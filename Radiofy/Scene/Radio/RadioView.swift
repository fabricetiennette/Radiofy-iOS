import SwiftUI

struct RadioView: View {
    @StateObject var viewModel: RadioViewModel
    
    @State private var showDiscoverList = false

    private let featuredColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Section 1: Featured radios, live from the API
                    FeaturedStationsGrid(
                        state: viewModel.featuredState,
                        stations: viewModel.featuredStations,
                        columns: featuredColumns,
                        retry: { Task { await viewModel.loadFeaturedStations() } }
                    )
                    .padding(20)

                    // Section 2: On Air Now (horizontal)
                    SectionHeader("On Air Now")
                        .padding(.bottom, -10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(0..<8) { i in
                                ShowCardLarge(
                                    showTitle: sampleShows[i % sampleShows.count].title,
                                    subtitle: sampleShows[i % sampleShows.count].subtitle
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .scrollIndicators(.hidden)

                    // Section 3: Smaller carousel
                    SectionHeader("Découvertes", showsChevron: true) {
                        showDiscoverList = true
                    }
                    .padding(.top, 14)
                    .padding(.bottom, -4)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<12) { i in
                                ShowCardSmall(
                                    title: sampleSmall[i % sampleSmall.count]
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .scrollIndicators(.hidden)

                    // New Section: Latest Radio Episodes
                    SectionHeader("Latest Radio Episodes", showsChevron: true)
                        .padding(.top, 14)
                        .padding(.bottom, -16)
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 18) {
                            ForEach(sampleEpisodePages.indices, id: \.self) { pageIndex in
                                LatestEpisodePage(episodes: sampleEpisodePages[pageIndex])
                                    .containerRelativeFrame(.horizontal) { length, _ in
                                        min(length * 0.80, 430)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.horizontal, 20)
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)

                    // Section 4: More blocks placeholder
                    SectionHeader("Plus")
                    VStack(spacing: 12) {
                        ForEach(0..<2) { i in
                            MoreRow(title: "Bloc supplémentaire \(i+1)")
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 24)
                }
                .padding(.bottom, 24)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationDestination(isPresented: $showDiscoverList) {
                DiscoverListView()
            }
            .task {
                await viewModel.loadFeaturedStations()
            }
        }
    }
}

// MARK: - Reusable Components

private struct SectionHeader: View {
    let title: String
    var showsChevron: Bool = false
    var action: (() -> Void)? = nil

    init(_ title: String, showsChevron: Bool = false, action: (() -> Void)? = nil) {
        self.title = title
        self.showsChevron = showsChevron
        self.action = action
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.white)
                .accessibilityAddTraits(.isHeader)
            if showsChevron {
                Button {
                    action?()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2.bold())
                        .foregroundStyle(.gray)
                }
                .accessibilityLabel("Voir plus pour \(title)")
                .buttonStyle(.plain)
                
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

private struct FeaturedStationsGrid: View {
    let state: LoadState
    let stations: [RadioStation]
    let columns: [GridItem]
    let retry: () -> Void

    var body: some View {
        switch state {
        case .idle, .loading:
            LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                ForEach(0..<6, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.white.opacity(0.08))
                        .frame(height: 110)
                }
            }
            .accessibilityLabel("Loading stations")

        case .loaded:
            LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                ForEach(stations) { station in
                    RadioTileLarge(station: station)
                }
            }

        case .failed(let message):
            VStack(spacing: 12) {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)

                Button("Try again", action: retry)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule().fill(.white.opacity(0.12))
                    )
                    .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
        }
    }
}

private struct RadioTileLarge: View {
    let station: RadioStation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 110)
                .overlay {
                    // Most stations come back with an empty favicon, so the gradient
                    // stays visible as the fallback rather than an empty box.
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
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Text(station.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
        }
        .accessibilityElement(children: .combine)
    }

    private var placeholderIcon: some View {
        Image(systemName: "dot.radiowaves.left.and.right")
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(.white.opacity(0.9))
    }
}

private struct ShowCardLarge: View {
    let showTitle: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(LinearGradient(colors: [.indigo, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 300, height: 200)
                    .overlay(
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .foregroundStyle(.white.opacity(0.85))
                            .offset(y: 10)
                    )
            }

            Text(showTitle)
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(2)
        }
        .frame(width: 300)
    }
}

private struct ShowCardSmall: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 160, height: 100)
                .overlay(
                    Image(systemName: "music.quarternote.3")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                )
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
        }
        .frame(width: 160)
    }
}

private struct MoreRow: View {
    let title: String
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.3))
                .frame(width: 46, height: 46)
                .overlay(
                    Image(systemName: "wave.3.right")
                        .foregroundStyle(.white)
                )
            Text(title)
                .foregroundStyle(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.06))
        )
    }
}

private struct DiscoverListView: View {
    var body: some View {
        List(sampleSmall, id: \.self) { item in
            Text(item)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .listRowBackground(Color.black)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Découvertes")
    }
}

// New Episode model and row view
private struct Episodee: Identifiable {
    let id = UUID()
    let show: String
    let title: String
    let description: String
}


private struct LatestEpisodePage: View {
    let episodes: [Episodee]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(episodes.enumerated()), id: \.element.id) { index, episode in
                LatestEpisodeRow(episode: episode)

                if index < episodes.count - 1 {
                    Divider()
                        .overlay(Color.white.opacity(0.16))
                        .padding(.leading, 112)
                }
            }
        }
    }
}

private struct LatestEpisodeRow: View {
    let episode: Episodee

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 84, height: 88)
                .overlay(
                    Image(systemName: "square.stack.3d.up")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(episode.show.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.gray)
                    .lineLimit(1)

                Text(episode.title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(episode.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.62))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                // More button action
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("More options for \(episode.title)")
            
        }
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
        
    }
}

// MARK: - Sample Data
// Sections below still run on mock data until their endpoints exist.

private let sampleShows: [(title: String, subtitle: String)] = [
    ("The Rebecca Judd Show", "Big hits, throwbacks, and the best"),
    ("Hip-Hop Now", "Fresh tracks and exclusive interviews"),
    ("Indie Waves", "Your daily dose of indie"),
    ("Afrobeats Hour", "Vibes from across the continent"),
    ("Classic Rock", "Legends and anthems"),
    ("Electro Night", "Beats to keep you moving"),
    ("Latin Heat", "Reggaeton y más"),
    ("Jazz Lounge", "Smooth and cozy")
]

private let sampleSmall: [String] = [
    "Morning Mix", "Chill Focus", "Workout Boost", "Late Night", "Acoustic", "Pop Rising",
    "Piano", "Deep House", "Throwback", "Folk", "K-Pop", "R&B"
]

private let sampleEpisodes: [Episodee] = [
    Episodee(show: "RADIO GENÈSE AVEC EBONY", title: "L'album, le concept", description: "Ebony revient sur..."),
    Episodee(show: "THE ZANE LOWE SHOW", title: "Angèle and Lykke Li", description: "The European pop stars join Zane..."),
    Episodee(show: "APPLE MUSIC SPECIALS", title: "VERZUZ: French Montana x Rick Ross", description: "Relive the legendary MCs...")
]

private let sampleEpisodePages: [[Episodee]] = [
    sampleEpisodes,
    [
        Episodee(show: "SOULECTION RADIO", title: "Sade Tribute Mix", description: "A smooth selection of soulful classics..."),
        Episodee(show: "RADIO GENÈSE AVEC EBONY", title: "Invités: JoA & Sheryfa", description: "Ebony receives special guests for a deep conversation..."),
        Episodee(show: "CLUB RADIO", title: "Weekend Warmup", description: "New mixes and dance tracks for the weekend...")
    ]
]

#if DEBUG
#Preview {
    let viewModel = RadioViewModel(
        authService: AuthService(baseURL: AppConfig.apiBaseURL),
        radioService: PreviewRadioService()
    )
    NavigationStack {
        RadioView(viewModel: viewModel)
    }.preferredColorScheme(.dark)
}
#endif
