//
//  Episode.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
    var title: String
    var pubDate: Date
    let description: String
    let author: String
    var imageUrl: String?
    let streamUrl: String
    var fileUrl: String?
    var duration: Double?
    var mainDescription: String?
    var mainTitle: String?

    init(feedItem: RSSFeedItem, feed: RSSFeed) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.duration = feedItem.iTunes?.iTunesDuration
        self.mainDescription = feed.description
        self.mainTitle = feed.title
    }
}
