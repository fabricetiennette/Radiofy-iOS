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

final class SignUpServices: SignUpModule.Service {

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

    func createUser(name: String, password: String, email: String, callback: @escaping CallbackAuthResult) {
        firebaseAuth.createUser(withEmail: email, password: password) { auth, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            if let user = auth?.user {
                callback(.success(user))
                return
            }
        }
    }

    func linkUserToAnonymous(email: String, password: String, callback: @escaping CallbackAuthResult) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        firebaseAuth.currentUser?.link(with: credential, completion: { auth, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            if let user = auth?.user {
                callback(.success(user))
                return
            }
        })
    }

    func saveUserToDatabase(email: String, name: String, callback: @escaping CallbackResult) {
        guard let uid = currentUser?.uid else { return }
        database.collection("users").document(email)
            .setData(["name": name, "uid": uid, "photoURL": ""]
            ) { error in
                if let error = error {
                    callback(.failure(error))
                }
                callback(.success(()))
            }
    }

    func sendEmailVerificationToUser(callback: @escaping (Result<Any, Error>) -> Void) {
        currentUser?.sendEmailVerification(completion: { (error) in
            if let error = error {
                callback(.failure(error))
            }
            callback(.success("success"))
        })
    }
}
