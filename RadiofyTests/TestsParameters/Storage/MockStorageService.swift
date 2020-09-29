//
//  MockStorageService.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseStorage
@testable import Radiofy

class MockStorageService: StorageProtocol {

    private let fakeStorageResponse: FakeStorageResponse

    init(fakeStorageResponse: FakeStorageResponse) {
        self.fakeStorageResponse = fakeStorageResponse
    }

    func saveImageDetails(with email: String) {}

    func saveUserImageToDatabase(email: String, data: Data, callback: @escaping (Result<URL, Error>) -> Void) {
        let url = URL(string: "")
        let error = fakeStorageResponse.error

        if let error = error {
            callback(.failure(error))
            return
        }
        if let url = url {
            callback(.success(url))
        }
    }

    func userStorageReference(email: String) -> StorageReference {
        let reference = (fakeStorageResponse.ref?.reference ?? nil)!
        return reference
    }

    func deleteUserImage(with email: String, callback: @escaping (Result<Void, Error>) -> Void) {
        let error = fakeStorageResponse.error

        if let error = error {
            callback(.failure(error))
            return
        }
        callback(.success(()))
    }
}
