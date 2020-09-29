//
//  AboutViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import SafariServices

enum RadiofyAbout: String {
    case thirdPartySoftware
    case privacy
    case termOfService
}

class AboutViewModel {

    var safariServicesHandler: ((_ vc: SFSafariViewController ) -> Void)?
    var errorHandler: ((_ title: String, _ message: String) -> Void)?

    // MARK: - Injection

    private let firestoreService: FirestoreService

    // MARK: - Init

    init(firestoreService: FirestoreService = .init()) {
        self.firestoreService = firestoreService
    }

    // MARK: - viewModel Method

    func showSafariView(with radiofyUrl: RadiofyAbout) {
        firestoreService.getDocument(collection: "RadiofyAbout", document: radiofyUrl.rawValue, get: "url") { result in
            switch result {
            case .success(let url):
                self.openThirdPartySoftwareWebPage(with: url)
            case .failure:
                self.errorHandler?(L1s.error, L1s.openDocError)
            }
        }
    }

    // MARK: - Private

    private func openThirdPartySoftwareWebPage(with url: String) {
        if let myUrl = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: myUrl, configuration: config)
            vc.preferredBarTintColor = UIColor(cgColor: #colorLiteral(red: 0.2117426097, green: 0.2117787898, blue: 0.2117346823, alpha: 1))
            vc.preferredControlTintColor = .white
            vc.modalPresentationStyle = .formSheet
            safariServicesHandler?(vc)
        }
    }
}
