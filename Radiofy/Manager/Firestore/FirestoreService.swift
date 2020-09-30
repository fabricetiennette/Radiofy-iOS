//
//  FirestoreService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

public class FirestoreService {

    private var firestoreManager: FirestoreProtocol

    init(firestoreManager: FirestoreProtocol = FirestoreManager()) {
        self.firestoreManager = firestoreManager
    }

    // get radio from database with collection name
    func getStationDetails(
        with collectionName: String,
        callback: @escaping (Result<[RadioStation], Error>) -> Void
    ) {
        firestoreManager.getStationDetails(with: collectionName) { result in
            switch result {
            case .success(let radioStation):
                callback(.success(radioStation))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    func isPurchasesAuthorized(callback: @escaping (Result<Bool, Error>) -> Void) {
        firestoreManager.isPurchasesAuthorized { result in
            switch result {
            case .success(let authorization):
                callback(.success(authorization))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    func getPodcastStationFromDatabase(
           with collectionName: String,
           callback: @escaping (Result<[PodcastStation], Error>) -> Void
    ) {
        firestoreManager.getPodcastStationFromDatabase(with: collectionName) { result in
            switch result {
            case .success(let podcastStation):
                callback(.success(podcastStation))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    func getRadioPodcastFromDatabase(
        with collectionName: String,
        callback: @escaping (Result<[RadioPodcast], Error>) -> Void
    ) {
        firestoreManager.getRadioPodcastFromDatabase(with: collectionName) { result in
            switch result {
            case .success(let radioPodcasts):
                callback(.success(radioPodcasts))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // get user info from database
    func getUserInfoFromDatabase(
        email: String,
        callback: @escaping (Result<(String, String), Error>) -> Void
    ) {
        firestoreManager.getUserInfoFromDatabase(email: email) { result in
            switch result {
            case .success((let name, let photoUrl)):
                callback(.success((name, photoUrl)))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // save user to database
    func saveUserToDatabase(
        email: String,
        name: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        firestoreManager.saveUserToDatabase(email: email, name: name) { result in
            switch result {
            case .success:
                callback(.success(()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // merge new picture and userner into to existing one
    func mergeNewInfoToUserDatabase(
        email: String,
        url: URL,
        userName: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        firestoreManager.mergeNewInfoToUserDatabase(email: email, url: url, userName: userName) { result in
            switch result {
            case .success:
                callback(.success(()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Get User Name when it change
    func getUserName(
        email: String,
        callback: @escaping (Result<String, Error>) -> Void
    ) {
        firestoreManager.getUserName(email: email) { result in
            switch result {
            case .success(let name):
                callback(.success(name))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Get document
    func getDocument(
        collection: String,
        document: String,
        get: String,
        callback: @escaping (Result<String, Error>) -> Void
    ) {
        firestoreManager.getDocument(collection: collection, document: document, get: get) { result in
            switch result {
            case .success(let document):
                callback(.success(document))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Delete User in database
    func deleteUserInDatabase(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        firestoreManager.deleteUserInDatabase(with: email) { result in
            switch result {
            case .success:
                callback(.success(()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
