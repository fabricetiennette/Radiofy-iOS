//
//  NetworkManager.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 08/05/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Alamofire

class NetworkManager {

    // shared instance
    static let shared = NetworkManager()

    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onQueue: .main, onUpdatePerforming: { status in

            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the WWAN connection")
            }
        })
    }
}
