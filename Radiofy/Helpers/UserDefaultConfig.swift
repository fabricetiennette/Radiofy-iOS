//
//  UserDefaultConfig.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 22/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

struct UserDefaultConfig {
    @UserDefault("recentlyPlayed", defaultValue: [])
    static var recentlyPlayed: [String]

    @UserDefault("favoriteStations", defaultValue: [])
    static var favoriteStations: [String]

}
