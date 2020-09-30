//swiftlint:disable force_cast
//
//  FirestoreManager.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 09/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager: FirestoreProtocol {

    let database = Firestore.firestore()

    // get radio from database with collection name
    func getStationDetails(
        with collectionName: String,
        callback: @escaping (Result<[RadioStation], Error>) -> Void
    ) {
        var stations: [RadioStation] = []
        database.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                callback(.failure(error))
                return
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard
                        let imageURL = data["imageURL"],
                        let name = data["name"],
                        let streamURL = data["streamURL"],
                        let unformattedColor = data["mainColor"]
                        else { return }
                    let station = RadioStation(
                        name: name as! String,
                        imageURL: imageURL as! String,
                        streamURL: streamURL as! String,
                        unformattedColor: unformattedColor as! String
                    )
                    stations.append(station)
                }
                callback(.success(stations))
            }
        }
    }

    func getPodcastStationFromDatabase(
        with collectionName: String,
        callback: @escaping (Result<[PodcastStation], Error>) -> Void
    ) {
        var podcast: [PodcastStation] = []
        database.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                callback(.failure(error))
                return
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard
                        let imageURL = data["imageURL"],
                        let name = data["name"],
                        let searchName = data["searchName"]
                        else { return }
                    let podcastStations = PodcastStation(
                        name: name as! String,
                        imageUrl: imageURL as! String,
                        searchName: searchName as! String
                    )
                    podcast.append(podcastStations)
                }
                callback(.success(podcast))
            }
        }
    }

    func getRadioPodcastFromDatabase(
        with collectionName: String,
        callback: @escaping (Result<[RadioPodcast], Error>) -> Void
    ) {
        var radioPodcast: [RadioPodcast] = []
        database.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                callback(.failure(error))
                return
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard
                        let feedURL = data["feedURL"],
                        let name = data["name"]
                        else { return }
                    let radioPodcasts = RadioPodcast(
                        name: name as! String,
                        feedURL: feedURL as! String
                    )
                    radioPodcast.append(radioPodcasts)
                }
                callback(.success(radioPodcast))
            }
        }
    }

    // get user info from database
    func getUserInfoFromDatabase(
        email: String,
        callback: @escaping (Result<(String, String), Error>) -> Void
    ) {
        let docRef = database.collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let error = error {
                callback(.failure(error))
                return
            }
            if let document = document, document.exists {
                let dataDescription = document.data()
                guard
                    let name = dataDescription?["name"],
                    let photoURL = dataDescription?["photoURL"]
                    else { return }
                callback(.success((
                    String(describing: name), String(describing: photoURL)
                    ))
                )
            }
        }
    }

    // save user to database
    func saveUserToDatabase(
        email: String,
        name: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.collection("users").document(email)
            .setData(["name": name, "uid": uid, "photoURL": ""]
            ) { error in
                if let error = error {
                    callback(.failure(error))
                }
                callback(.success(()))
        }
    }

    // check if purchases is authorized
    func isPurchasesAuthorized(callback: @escaping (Result<Bool, Error>) -> Void) {
        database.collection("purchases").document("purchase")
            .getDocument { (authorizationDoc, error) in
                if let error = error {
                    callback(.failure(error))
                    return
                }
                guard let authorization = authorizationDoc?.get("authorization") as? Bool else { return }
                callback(.success(authorization))
            }
    }

    // merge new picture and userner into to existing one
    func mergeNewInfoToUserDatabase(
        email: String,
        url: URL,
        userName: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        let dataReference = database.collection("users").document(email)
        let urlString = url.absoluteString
        dataReference.setData(["name": userName, "photoURL": urlString], merge: true) { error in
            if let error = error {
                callback(.failure(error))
                return
            }
            callback(.success(()))
        }
    }

    // Get User Name when it change
    func getUserName(
        email: String,
        callback: @escaping (Result<String, Error>) -> Void
    ) {
        let db = database.collection("users").document(email)
        db.addSnapshotListener { documentSnapshot, error in

            if let error = error {
                callback(.failure(error))
                return
            }
            guard let name = documentSnapshot?.get("name") as? String else { return }
            callback(.success(name))
        }
    }

    // Get document
    func getDocument(
        collection: String,
        document: String,
        get: String,
        callback: @escaping (Result<String, Error>) -> Void
    ) {
        let docRef = database.collection(collection).document(document)
        docRef.getDocument { (document, error) in
            if let error = error {
                callback(.failure(error))
                return
            }
            guard let doc = document?.get(get) as? String else { return }
            callback(.success(doc))
        }
    }

    // Delete User in database
    func deleteUserInDatabase(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        let db = self.database.collection("users").document(email)
        db.delete { error in
            if let error = error {
                callback(.failure(error))
                return
            }
            callback(.success(()))
        }
    }
}

extension QueryDocumentSnapshot: QueryDocumentSnapshotProtocol {}
