//
//  OnBoardingService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth

struct OnBoardingService: OnBoardingModule.Service {

    private let firebaseAuth = Auth.auth()

    func signInAnonymously(callback: @escaping (AuthResult) -> Void) {
        firebaseAuth.signInAnonymously { (authResult, error) in
            if let error = error {
                callback(.failure(error))
            } else {
                guard let user = authResult?.user else { return }
                callback(.success(user))
            }
        }
    }
}
