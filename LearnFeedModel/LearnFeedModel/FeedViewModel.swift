import Foundation
import Combine

enum FeedTab: String, CaseIterable, Identifiable {
    case forYou = "For You"
    case friends = "Friends"
    case learn = "Learn"

    var id: String { rawValue }
}

struct Video: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let channel: String
    let views: String
    let timeAgo: String
    let thumbnailSymbol: String        // SF Symbol fallback
    let thumbnailImageName: String?    // Optional real image
    let category: String?              // Used for Learn filters

    init(
        title: String,
        channel: String,
        views: String,
        timeAgo: String,
        thumbnailSymbol: String,
        thumbnailImageName: String? = nil,
        category: String? = nil
    ) {
        self.title = title
        self.channel = channel
        self.views = views
        self.timeAgo = timeAgo
        self.thumbnailSymbol = thumbnailSymbol
        self.thumbnailImageName = thumbnailImageName
        self.category = category
    }
}

final class FeedViewModel: ObservableObject {
    @Published var selectedTab: FeedTab = .forYou

    // MARK: - For You (non-educational content)
    private let forYouVideos: [Video] = [
        .init(
            title: "Epic Street Food Tour",
            channel: "Nomad Bites",
            views: "1.2M views",
            timeAgo: "2 days ago",
            thumbnailSymbol: "fork.knife",
            thumbnailImageName: "StreetFoodTour"          // 🖼️ 1
        ),
        .init(
            title: "iPhone Tips You Didn’t Know",
            channel: "TechQuick",
            views: "823K views",
            timeAgo: "1 week ago",
            thumbnailSymbol: "iphone.gen4",
            thumbnailImageName: "IphoneTricks"            // 🖼️ 2
        ),
        .init(
            title: "Goal Highlights: Weekend Roundup",
            channel: "Footy Zone",
            views: "2.1M views",
            timeAgo: "18 hours ago",
            thumbnailSymbol: "soccerball",
            thumbnailImageName: "WeekRoundUp"            // 🖼️ 3
        ),
        .init(
            title: "Morning Jazz Playlist",
            channel: "Cafe Vibes",
            views: "312K views",
            timeAgo: "5 days ago",
            thumbnailSymbol: "music.note.list"
        ),
        .init(
            title: "Hidden Travel Gems in Italy",
            channel: "Roam With Me",
            views: "646K views",
            timeAgo: "3 days ago",
            thumbnailSymbol: "airplane"
        )
    ] + (0..<8).map { i in
        .init(
            title: "Daily Shorts #\(i + 1)",
            channel: "QuickClips",
            views: "\(Int.random(in: 50...500))K views",
            timeAgo: "\(Int.random(in: 1...6)) days ago",
            thumbnailSymbol: "sparkles"
        )
    }

    // MARK: - Friends (non-educational, friends’ picks)
    private let friendsVideos: [Video] = [
        .init(
            title: "Best Comedy Moments 2025",
            channel: "LaughLab",
            views: "971K views",
            timeAgo: "4 days ago",
            thumbnailSymbol: "theatermasks",
            thumbnailImageName: "BestComedyMoments"       // 🖼️ 4
        ),
        .init(
            title: "Insane Drift Compilation",
            channel: "Torque TV",
            views: "1.6M views",
            timeAgo: "1 day ago",
            thumbnailSymbol: "car.fill",
            thumbnailImageName: "DriftCompatition"        // 🖼️ 5
        ),
        .init(
            title: "Home Gym Setup Tour",
            channel: "Lift & Live",
            views: "210K views",
            timeAgo: "1 week ago",
            thumbnailSymbol: "dumbbell",
            thumbnailImageName: "HomeGym"                // 🖼️ 6
        ),
        .init(
            title: "Street Fashion Lookbook",
            channel: "City Threads",
            views: "408K views",
            timeAgo: "2 weeks ago",
            thumbnailSymbol: "tshirt"
        ),
        .init(
            title: "Quick Recipes Under 10 Min",
            channel: "Pan & Plan",
            views: "589K views",
            timeAgo: "3 days ago",
            thumbnailSymbol: "stove"
        )
    ] + (0..<8).map { i in
        .init(
            title: "Friends’ Picks #\(i + 1)",
            channel: "Shared Reels",
            views: "\(Int.random(in: 30...400))K views",
            timeAgo: "\(Int.random(in: 2...9)) days ago",
            thumbnailSymbol: "person.2.fill"
        )
    }

    // MARK: - Learn (educational feed)
    private let learnVideos: [Video] = [
        .init(
            title: "SwiftUI Layout in 15 Minutes",
            channel: "CodeCraft",
            views: "220K views",
            timeAgo: "6 days ago",
            thumbnailSymbol: "curlybraces",
            thumbnailImageName: "SwiftUiSetup",           // 🖼️ 7
            category: "Programming"
        ),
        .init(
            title: "Microeconomics Crash Course",
            channel: "Study Spark",
            views: "410K views",
            timeAgo: "1 week ago",
            thumbnailSymbol: "books.vertical",
            thumbnailImageName: "MicroeconomicsCourse",   // 🖼️ 8
            category: "Economics"
        ),
        .init(
            title: "Beginner Machine Learning Map",
            channel: "DataPath",
            views: "310K views",
            timeAgo: "5 days ago",
            thumbnailSymbol: "brain.head.profile",
            thumbnailImageName: "BegginersMLmap",         // 🖼️ 9
            category: "Data Science"
        ),
        .init(
            title: "Statistical Thinking Essentials",
            channel: "Math Mind",
            views: "180K views",
            timeAgo: "3 days ago",
            thumbnailSymbol: "function",
            category: "Math"
        ),
        .init(
            title: "Architecture: Form & Function",
            channel: "StudioLine",
            views: "95K views",
            timeAgo: "2 weeks ago",
            thumbnailSymbol: "ruler",
            category: "Architecture"
        )
    ] + (0..<8).map { i in
        .init(
            title: "Learn Bite #\(i + 1)",
            channel: "Study Shorts",
            views: "\(Int.random(in: 20...250))K views",
            timeAgo: "\(Int.random(in: 1...7)) days ago",
            thumbnailSymbol: "graduationcap",
            category: "Study Skills"
        )
    }

    // MARK: - Public API
    func videos(for tab: FeedTab) -> [Video] {
        switch tab {
        case .forYou:
            return forYouVideos
        case .friends:
            return friendsVideos
        case .learn:
            return learnVideos
        }
    }
}

