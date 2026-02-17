//
//  OnBoardingService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth
import Combine

//struct OnBoardingService: OnBoardingModule.Service {
//
//    private let firebaseAuth = Auth.auth()
//
//    func signInAnonymously() -> AnyPublisher<UserProtocol, Error> {
//        Deferred {
//
//            Future { handler in
//                firebaseAuth.signInAnonymously { data, error in
//                    if let error = error {
//                        handler(.failure(error))
//                    } else {
//                        guard let user = data?.user else { return }
//                        handler(.success(user))
//                    }
//                }
//            }
//        }.eraseToAnyPublisher()
//    }
//}
