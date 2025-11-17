import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top bar (YouTube-ish)
                HStack {
                    Image(systemName: "play.rectangle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.red)
                    Text("YouTube:Educational")
                        .font(.title3).fontWeight(.semibold)
                    Spacer()
                    HStack(spacing: 16) {
                        Image(systemName: "airplayvideo")
                        Image(systemName: "magnifyingglass")
                        Image(systemName: "person.circle")
                    }
                    .font(.title3)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))

                // Red divider (accent)
                Rectangle()
                    .fill(Color.red.opacity(0.85))
                    .frame(height: 2)

                // Segmented tabs (For You / Friends / Learn)
                Picker("Feed", selection: $viewModel.selectedTab) {
                    ForEach(FeedTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)

                // Content changes depending on tab
                if viewModel.selectedTab == .learn {
                    // Special layout with filters at top
                    LearnFeedView(viewModel: viewModel)
                } else {
                    // Regular feed list (scrolls) for For You / Friends
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.videos(for: viewModel.selectedTab)) { video in
                                VideoRow(video: video)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .tint(.red) // overall accent closer to YouTube
    }
}

// MARK: - Row

struct VideoRow: View {
    let video: Video

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Thumbnail: image if available, otherwise SF Symbol placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))

                if let imageName = video.thumbnailImageName {
                    // Real picture from your Assets
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    // Fallback: SF Symbol, like before
                    Image(systemName: video.thumbnailSymbol)
                        .font(.system(size: 64, weight: .regular))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 200)
            .clipped()

            // Title & meta
            Text(video.title)
                .font(.headline)
                .lineLimit(2)

            HStack(spacing: 8) {
                Text(video.channel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("•")
                    .foregroundStyle(.secondary)
                Text(video.views)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("•")
                    .foregroundStyle(.secondary)
                Text(video.timeAgo)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .lineLimit(1)
        }
    }
}

// MARK: - Learn Feed with filters

struct LearnFeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    @State private var selectedCategory: String = "All"

    private let categories = [
        "All",
        "Programming",
        "Math",
        "Data Science",
        "Architecture",
        "Economics",
        "Study Skills"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Category chips at the top
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            Text(category)
                                .font(.subheadline)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    selectedCategory == category
                                    ? Color.red.opacity(0.9)
                                    : Color(.secondarySystemBackground)
                                )
                                .foregroundColor(selectedCategory == category ? .white : .primary)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
            }

            // Filtered Learn videos
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredVideos) { video in
                        VideoRow(video: video)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
            }
        }
    }

    private var filteredVideos: [Video] {
        let allLearn = viewModel.videos(for: .learn)
        if selectedCategory == "All" {
            return allLearn
        } else {
            return allLearn.filter { $0.category == selectedCategory }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

