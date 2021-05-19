//
//  Storyboarded.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

/// A protocol that lets us instantiate view controllers from Main storyboard.
protocol Storyboarded { }

enum StoryboardName: String {
    case start
    case home
    case search
    case library
    case player
    case radio
    case podcast
    case subscription

    var name: String {
        switch self {
        case .start: return "Start"
        case .home: return "Home"
        case .library: return "Library"
        case .search: return "Search"
        case .player: return "Player"
        case .radio: return "Radio"
        case .podcast: return "Podcast"
        case .subscription: return "Subscription"
        }
    }
}

extension Storyboarded where Self: UIViewController {
    // Creates a view controller from our storyboard. This relies on view controllers having the same storyboard identifier as their class name. This method shouldn't be overridden in conforming types.
    static func instantiate(from storyboarded: StoryboardName) -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboarded.name, bundle: Bundle.main)

        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
