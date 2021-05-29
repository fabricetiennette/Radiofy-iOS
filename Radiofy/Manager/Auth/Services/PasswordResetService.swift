//
//  PasswordResetService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 29/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Firebase
import Combine

struct PasswordResetService: PasswordResetModule.Service {

    private let firebaseAuth = Auth.auth()

    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { handler in
                firebaseAuth.sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        handler(.failure(error))
                    } else {
                        handler(.success(()))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
