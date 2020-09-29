//
//  FakeNetworkResponse.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
@testable import Radiofy

class FakeNetworkResponse {
    class NetworkError: Error {}
    static let networkError = NetworkError()
}
