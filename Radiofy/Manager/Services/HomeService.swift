//
//  HomeService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/07/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Combine
import FirebaseFirestore

struct HomeService: HomeModule.Service {

    private let database = Firestore.firestore()

    #warning("Check the use of this method")
    func saveDocumentToDatabase(imageUrl: String, mainColor: String, name: String, streamUrl: String) {}

    // get radio from database with collection name
    func getStationDetails(with collectionName: String) -> AnyPublisher<[RadioStation], Error> {
        Deferred {

            Future { handler in
                var stations: [RadioStation] = []
//                database.collection(collectionName).getDocuments { (querySnapshot, error) in
//                    if let error = error {
//                        handler(.failure(error))
//                        return
//                    } else {
//                        for document in querySnapshot!.documents {
//                            let data = document.data()
//                            guard
//                                let imageURL = data["imageURL"],
//                                let name = data["name"],
//                                let streamURL = data["streamURL"],
//                                let unformattedColor = data["mainColor"]
//                            else { return }
//                            let station = RadioStation(
//                                // swiftlint:disable:next force_cast
//                                name: name as! String,
//                                // swiftlint:disable:next force_cast
//                                imageURL: imageURL as! String,
//                                // swiftlint:disable:next force_cast
//                                streamURL: streamURL as! String,
//                                // swiftlint:disable:next force_cast
//                                unformattedColor: unformattedColor as! String
//                            )
//                            stations.append(station)
//                        }
//                        handler(.success(stations))
//                    }
//                }
            }
        }.eraseToAnyPublisher()
    }

    // check if develop stage
    func isFullAppAccessAuthorized() -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { handler in
                database
                    .collection("development")
                    .document("develop")
                    .getDocument { (authorizationDoc, error) in
                        if let error = error {
                            handler(.failure(error))
                            return
                        }
                        guard let authorization = authorizationDoc?.get("release21") as? Bool else { return }
                        handler(.success(authorization))
                    }
            }
        }.eraseToAnyPublisher()
    }
}
