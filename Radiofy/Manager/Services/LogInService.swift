//
//  LogInServices.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 25/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

struct LogInService: LogInModule.Service {

    private let firebaseAuth = Auth.auth()

    var isUserEmailVerified: Bool {
        guard let user = firebaseAuth.currentUser else { return false }
        return user.isEmailVerified
    }

    func signOutUser() -> AnyPublisher<Any, Error> {
        Deferred {
            Future { handler in
                do {
                    try firebaseAuth.signOut()
                    handler(.success("success"))
                } catch let signOutError {
                    handler(.failure(signOutError))
                }
            }
        }.eraseToAnyPublisher()
    }

    func signIn(email: String, password: String) -> AnyPublisher<UserProtocol, Error> {
        Deferred {
            Future { handler in
                firebaseAuth.signIn(withEmail: email, password: password) { auth, error in
                    if let error = error {
                        handler(.failure(error))
                    } else {
                        guard let user = auth?.user else { return }
                        handler(.success(user))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
