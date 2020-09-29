//
//  MockFirestoreService.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
@testable import Radiofy

class MockFirestoreService: FirestoreProtocol {

    private let fakeFirestoreResponse: FakeFirestoreResponse

    init(fakeFirestoreResponse: FakeFirestoreResponse) {
        self.fakeFirestoreResponse = fakeFirestoreResponse
    }

    func getStationDetails(with collectionName: String, callback: @escaping (Result<[RadioStation], Error>) -> Void) {
        let error = fakeFirestoreResponse.error
        let doc = fakeFirestoreResponse.querySnapshot?.radio

        if let error = error {
            callback(.failure(error))
            return
        }
        if let radio = doc {
            callback(.success(radio))
            return
        }
    }

    func getUserInfoFromDatabase(email: String, callback: @escaping (Result<(String, String), Error>) -> Void) {
        let name = "username"
        let photoUrl = "photoUrl"
        let error = fakeFirestoreResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success((name, photoUrl)))
        }
    }

    func saveUserToDatabase(email: String, name: String, callback: @escaping (Result<Void, Error>) -> Void) {
        let error = fakeFirestoreResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(()))
        }
    }

    func mergeNewInfoToUserDatabase(email: String, url: URL, userName: String, callback: @escaping (Result<Void, Error>) -> Void) {
        let error = fakeFirestoreResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(()))
        }
    }

    func getUserName(email: String, callback: @escaping (Result<String, Error>) -> Void) {
        let username = "fakeName"
        let error = fakeFirestoreResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(username))
        }
    }

    func getDocument(collection: String, document: String, get: String, callback: @escaping (Result<String, Error>) -> Void) {
        let doc = "document name"
        let error = fakeFirestoreResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(doc))
        }
    }

    func deleteUserInDatabase(with email: String, callback: @escaping (Result<Void, Error>) -> Void) {
        let error = fakeFirestoreResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(()))
        }
    }
}
