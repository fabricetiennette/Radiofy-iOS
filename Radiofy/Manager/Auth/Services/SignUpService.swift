//
//  SignUpServices.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 17/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Combine

struct SignUpService: SignUpModule.Service {

    private let firebaseAuth = Auth.auth()
    private let database = Firestore.firestore()
    private let storage = Storage.storage()

    private var currentUser: User? {
        firebaseAuth.currentUser
    }

    var isAnonymous: Bool {
        if let user = currentUser, user.isAnonymous {
            return true
        } else {
            return false
        }
    }

    func deleteCurrentUser() {
        guard let user = currentUser else { return }
        if user.isAnonymous {
            user.delete()
        }
    }

    // Give user a default image profile
    func saveImageDetails(with email: String) {
        guard let image = UIImage(named: "placeholderPicture"),
              let data = image.jpegData(compressionQuality: 0.4) else { return }
        let imageName = "\(email)ProfilePhoto.jpg"
        let imageReference = storage.reference()
            .child("profilePhotosFolder")
            .child(imageName)
        imageReference.putData(data, metadata: nil) { _, _ in }
    }

    func createUser(name: String, password: String, email: String) -> AnyPublisher<UserProtocol, Error> {
        Deferred {

            Future { promise in
                firebaseAuth.createUser(withEmail: email, password: password) { auth, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        guard let user = auth?.user else { return }
                        promise(.success(user))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func linkUserToAnonymous(email: String, password: String) -> AnyPublisher<UserProtocol, Error> {
        Deferred {

            Future { promise in
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                firebaseAuth.currentUser?.link(with: credential, completion: { auth, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        guard let user = auth?.user else { return }
                        promise(.success(user))
                    }
                })
            }
        }.eraseToAnyPublisher()
    }

    func saveUserToDatabase(email: String, name: String) -> AnyPublisher<Void, Error> {
        Deferred {

            Future { promise in
                guard let uid = currentUser?.uid else { return }
                database
                    .collection("users")
                    .document(email)
                    .setData(["name": name, "uid": uid, "photoURL": ""]) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }

    func sendEmailVerificationToUser() -> AnyPublisher<Any, Error> {
        Deferred {

            Future { promise in
                currentUser?.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success("success"))
                    }
                })
            }
        }.eraseToAnyPublisher()
    }
}
