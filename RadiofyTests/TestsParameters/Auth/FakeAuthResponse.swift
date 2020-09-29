//
//  FakeAuthResponse.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
@testable import Radiofy

struct FakeAuthResponse {
    var authDataResult: FakeAuthDataResult?
    var error: Error?
}

struct FakeAuthDataResult {
    var user: FakeUser?
}

struct FakeUser: UserProtocol {
    var displayName: String?
    var email: String?
}
