//
//  StorageManager.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 22/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Firebase

class StorageManager: StorageProtocol {

    private let storage = Storage.storage()

    // Give user a default image profile
    func saveImageDetails(with email: String) {
        guard
            let image = UIImage(named: "placeholderPicture"),
            let data = image.jpegData(compressionQuality: 0.4) else { return }
        let imageName = "\(email)ProfilePhoto.jpg"
        let imageReference = storage.reference()
            .child("profilePhotosFolder")
            .child(imageName)
        imageReference.putData(data, metadata: nil) { _, _ in }
    }

    // Save user image to database and get image url
    func saveUserImageToDatabase(
        email: String,
        data: Data,
        callback: @escaping (Result<URL, Error>) -> Void
    ) {
        let imageName = "\(email)ProfilePhoto.jpg"
        let imageReference = storage.reference()
            .child("profilePhotosFolder")
            .child(imageName)

        imageReference.putData(data, metadata: nil) { (_, error) in
            if let error = error {
                callback(.failure(error))
                return
            }
            imageReference.downloadURL { (url, error) in
                if let error = error {
                    callback(.failure(error))
                    return
                }
                guard let url = url else {
                    callback(.failure(FireBaseError.somethingWentWrong))
                    return
                }
                callback(.success(url))
            }
        }
    }

    // Return user email storage reference
    func userStorageReference(email: String) -> StorageReference {
        let ref = storage.reference()
            .child("profilePhotosFolder/\(email)ProfilePhoto.jpg")
        return ref
    }

    // Delete User image in storage
    func deleteUserImage(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        let imageName = "\(email)ProfilePhoto.jpg"
        let imageReference = self.storage.reference()
            .child("profilePhotosFolder")
            .child(imageName)
        imageReference.delete { error in
            if let error = error {
                callback(.failure(error))
                return
            }
            callback(.success(()))
        }
    }
}
