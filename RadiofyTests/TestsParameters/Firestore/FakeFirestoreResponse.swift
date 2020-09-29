//
//  FakeFirestoreResponse.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
@testable import Radiofy

struct FakeFirestoreResponse {
    var querySnapshot: FakeQuerySnapshot?
    var error: Error?
}

struct FakeQuerySnapshot {
    var documents: [FakeQueryDocumentSnapshot]?
    var radio: [RadioStation]?
}

struct FakeQueryDocumentSnapshot: QueryDocumentSnapshotProtocol {
    var documentID: String
    var datas: [String: Any]

    func data() -> [String: Any] {
        return datas
    }
}
