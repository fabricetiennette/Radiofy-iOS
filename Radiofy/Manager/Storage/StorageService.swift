//
//  StorageService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseStorage

public class StorageService {

    private var storageManager: StorageProtocol

    init(storageManager: StorageProtocol = StorageManager()) {
        self.storageManager = storageManager
    }

    // Give user a default image profile
    func saveImageDetails(with email: String) {
        storageManager.saveImageDetails(with: email)
    }

    // Save user image to database and get image url
    func saveUserImageToDatabase(
        email: String,
        data: Data,
        callback: @escaping (Result<URL, Error>) -> Void
    ) {
        storageManager.saveUserImageToDatabase(email: email, data: data) { result in
            switch result {
            case .success(let url):
                callback(.success(url))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Return user email storage reference
    func userStorageReference(email: String) -> StorageReference {
        return storageManager.userStorageReference(email: email)
    }

    // Delete User image in storage
    func deleteUserImage(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        storageManager.deleteUserImage(with: email) { result in
            switch result {
            case .success:
                callback(.success(()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
