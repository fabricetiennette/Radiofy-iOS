//
//  FirestoreProtocol.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol QueryDocumentSnapshotProtocol {
    var documentID: String { get }
    func data() -> [String: Any]
}

typealias FirestoreResult = Result<[QueryDocumentSnapshotProtocol], Error>

protocol FirestoreProtocol {
    func getStationDetails(
        with collectionName: String,
        callback: @escaping (Result<[RadioStation], Error>) -> Void
    )
    func getPodcastStationFromDatabase(
           with collectionName: String,
           callback: @escaping (Result<[PodcastStation], Error>) -> Void
    )
    func getRadioPodcastFromDatabase(
        with collectionName: String,
        callback: @escaping (Result<[RadioPodcast], Error>) -> Void
    )
    func getUserInfoFromDatabase(
        email: String,
        callback: @escaping (Result<(String, String), Error>) -> Void
    )
    func saveUserToDatabase(
        email: String,
        name: String,
        callback: @escaping (Result<Void, Error>) -> Void
    )
    func mergeNewInfoToUserDatabase(
        email: String,
        url: URL,
        userName: String,
        callback: @escaping (Result<Void, Error>) -> Void
    )
    func getUserName(
        email: String,
        callback: @escaping (Result<String, Error>) -> Void
    )
    func getDocument(
        collection: String,
        document: String,
        get: String,
        callback: @escaping (Result<String, Error>) -> Void
    )
    func deleteUserInDatabase(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    )
}
