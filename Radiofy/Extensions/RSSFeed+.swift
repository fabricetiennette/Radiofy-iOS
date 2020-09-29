//
//  RSSFeed+.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 22/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {

  func toEpisodes() -> [Episode] {
    let imageUrl = iTunes?.iTunesImage?.attributes?.href

    var episodes: [Episode] = []
    items?.forEach({ (feedItem) in
        var episode = Episode(feedItem: feedItem, feed: self)

      if episode.imageUrl == nil {
        episode.imageUrl = imageUrl
      }

      episodes.append(episode)
    })
    return episodes
  }
}
