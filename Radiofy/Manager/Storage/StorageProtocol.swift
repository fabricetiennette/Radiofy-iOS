//
//  StorageProtocol.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol StorageProtocol {
    func saveImageDetails(with email: String)
    func saveUserImageToDatabase(
        email: String,
        data: Data,
        callback: @escaping (Result<URL, Error>) -> Void
    )
    func userStorageReference(email: String) -> StorageReference
    func deleteUserImage(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    )
}
