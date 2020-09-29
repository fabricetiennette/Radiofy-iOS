//
//  FakeStorageResponse.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
@testable import Radiofy
import FirebaseStorage

struct FakeStorageResponse {
    var ref: FakeReference?
    var error: Error?
}

struct FakeReference {
    var reference: StorageReference
}
