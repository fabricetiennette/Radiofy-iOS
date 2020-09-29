//
//  PodcastService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Alamofire
import FeedKit

enum EndPoints {
  static let iTunesSearchURL = "https://itunes.apple.com/search?"
}

struct PodcastService {

    func fetchEpisodes(
        feedUrl: String,
        callback: @escaping (Swift.Result<[Episode], Error>) -> Void) {
        guard let url = URL(string: feedUrl) else { return }
        DispatchQueue.global(qos: .background).async {

            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { (result) in

                if let err = result.error {
                    callback(.failure(err))
                    return
                }

                guard let feed = result.rssFeed else { return }

                let episodes = feed.toEpisodes()
                callback(.success(episodes))
            })
        }
    }

    func fetchPodcasts(
        searchText: String,
        callback: @escaping (Swift.Result<[Podcast], Error>) -> Void
    ) {
        let parameters = ["term": searchText, "media": "podcast"]
        Alamofire.request(
            EndPoints.iTunesSearchURL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: nil
        )
            .responseData { (dataResponse) in

                if let err = dataResponse.error {
                    callback(.failure(err))
                    return
                }

                guard let data = dataResponse.data else { return }
                do {
                    let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                    callback(.success(searchResult.results))

                } catch let decodeErr {
                    callback(.failure(decodeErr))
                }
        }
    }
}
