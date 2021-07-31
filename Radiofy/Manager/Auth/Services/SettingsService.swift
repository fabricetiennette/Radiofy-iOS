//
//  SettingsService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 31/07/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Firebase
import Combine

final class SettingsService: SettingsModule.Service {
    
    private let database = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    private let storage = Storage.storage()
    var handle: AuthStateDidChangeListenerHandle = Auth.auth()
    
    var currentUser: User? {
        return firebaseAuth.currentUser
    }

    var userEmail: String? {
        return firebaseAuth.currentUser?.email
    }

    var isAnonymous: Bool {
        if currentUser?.isAnonymous == true {
            return true
        } else {
            return false
        }
    }

    // Add authentication Listener
    func stateDidChangeForAuth() -> AnyPublisher<Void, Never> {
        Deferred {
            Future { [weak self] handle in
                guard let self = self else { return }
                self.handle = self.firebaseAuth.addStateDidChangeListener { _, user in
                    if user == nil {
                        handle(.success(()))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func removeListener() {
        firebaseAuth.removeStateDidChangeListener(handle)
    }
    
    // Sign Out user
    func signOutUser() -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [weak self] handle in
                guard let self = self else { return }
                do {
                    try self.firebaseAuth.signOut()
                    handle(.success(()))
                } catch let signOutError {
                    handle(.failure(signOutError))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Get User Name when it change
    func getUserName(email: String) -> AnyPublisher<String, Error> {
        Deferred {
            Future { [weak self] handle in
                guard let self = self else { return }
                let db = self.database.collection("users").document(email)
                db.addSnapshotListener { documentSnapshot, error in
                    
                    if let error = error {
                        handle(.failure(error))
                        return
                    }
                    guard let name = documentSnapshot?.get("name") as? String else { return }
                    handle(.success(name))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Return user email storage reference
    func userStorageReference(email: String) -> AnyPublisher<StorageReference, Never> {
        Deferred {
            Future { [weak self] handle in
                guard let self = self else { return }
                let ref = self.storage.reference().child("profilePhotosFolder/\(email)ProfilePhoto.jpg")
                handle(.success(ref))
            }
        }.eraseToAnyPublisher()
    }
}
