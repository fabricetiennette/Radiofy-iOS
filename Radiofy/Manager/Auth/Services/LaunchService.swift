//
//  LaunchService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth

struct LaunchService: LaunchModule.Service {

    private let auth = Auth.auth()

    var isUserLoggedIn: Bool {
        auth.currentUser != nil
    }

    func setFirebaseEmailLanguage() {
        let language = Locale.preferredLanguages.first
        auth.languageCode = language
    }
}
