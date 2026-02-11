//
//  SubscriptionViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 07/05/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import SafariServices
import FirebaseAuth

protocol SubscriptionViewModelDelegate: AnyObject {
    func signUpFirst()
}

class SubscriptionViewModel {

    private weak var delegate: SubscriptionViewModelDelegate?

    var errorHandler: ((_ title: String, _ message: String) -> Void)?
    var safariServicesHandler: ((_ vc: SFSafariViewController) -> Void)?
    var successHandler: (() -> Void)?
    var loadingHandler: (() -> Void)?

    private let firestoreService: FirestoreService
    private let legacyFirebaseAuthService: LegacyFirebaseAuthService

    init(
        delegate: SubscriptionViewModelDelegate?,
        firestoreService: FirestoreService = .init(),
        legacyFirebaseAuthService: LegacyFirebaseAuthService = .init()
    ) {
        self.delegate = delegate
        self.firestoreService = firestoreService
        self.legacyFirebaseAuthService = legacyFirebaseAuthService
    }

    func showSafariView(with radiofyUrl: RadiofyAbout) {
        firestoreService.getDocument(collection: "RadiofyAbout", document: radiofyUrl.rawValue, get: "url") { result in
            switch result {
            case .success(let url):
                self.openThirdPartySoftwareWebPage(with: url)
            case .failure:
                self.errorHandler?(L10n.error, L10n.couldNotOpenDocumentTryLater)
            }
        }
    }

    // MARK: - Private

    private func openThirdPartySoftwareWebPage(with url: String) {
        if let myUrl = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            let vc = SFSafariViewController(url: myUrl, configuration: config)
            vc.preferredBarTintColor = UIColor(cgColor: #colorLiteral(red: 0.2117426097, green: 0.2117787898, blue: 0.2117346823, alpha: 1))
            vc.preferredControlTintColor = .white
            vc.modalPresentationStyle = .formSheet
            safariServicesHandler?(vc)
        }
    }
}
