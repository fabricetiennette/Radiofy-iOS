//
//  SubscriptionViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 07/05/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Purchases
import SafariServices
import FirebaseAuth

protocol SubscriptionViewModelDelegate: class {
    func signUpFirst()
}

class SubscriptionViewModel {

    private weak var delegate: SubscriptionViewModelDelegate?

    var errorHandler: ((_ title: String, _ message: String) -> Void)?
    var safariServicesHandler: ((_ vc: SFSafariViewController) -> Void)?
    var packageHanlder: ((_ package: Purchases.Package) -> Void)?
    var successHandler: (() -> Void)?
    var loadingHandler: (() -> Void)?

    private let purchases: Purchases
    private let firestoreService: FirestoreService
    private let authService: AuthService

    var package: Purchases.Package? {
        didSet {
            guard let myPackage = package else { return }
            packageHanlder?(myPackage)
        }
    }

    init(
        delegate: SubscriptionViewModelDelegate?,
        purchases: Purchases = .shared,
        firestoreService: FirestoreService = .init(),
        authService: AuthService = .init()
    ) {
        self.delegate = delegate
        self.purchases = purchases
        self.firestoreService = firestoreService
        self.authService = authService
    }

    func getPackagePrice() {
        purchases.offerings { (offerings, error) in
            if let error = error {
                self.errorHandler?(L1s.error, error.localizedDescription)
            } else {
                self.package = offerings?.current?.monthly
            }
        }
    }

    func purchase() {
        guard let package = package else {
            self.errorHandler?(L1s.error, "Something went wrong retry later.")
            return
        }
        purchases.purchasePackage(package) { (_, purchaserInfo, error, userCancelled) in
            DispatchQueue.main.async {
                 self.loadingHandler?()
                if let error = error {
                    self.loadingHandler?()
                    switch Purchases.ErrorCode(_nsError: error as NSError).code {
                    case .productAlreadyPurchasedError:
                        self.errorHandler?(L1s.error, "The device account already owns this product.")
                    case .purchaseInvalidError:
                        self.errorHandler?(L1s.error, "Ensure the device payment method is valid.")
                    default:
                        break
                    }
                } else if userCancelled == true {
                    self.loadingHandler?()
                }

                if purchaserInfo?.entitlements["Premium"]?.isActive == true {
                    if self.authService.isAnonymous {
                        self.successHandler?()
                        self.delegate?.signUpFirst()
                    } else {
                        NotificationCenter.default.post(
                            name: SettingsViewModel.NotificationDone,
                            object: nil
                        )
                    }
                }
            }
        }
    }

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
            let vc = SFSafariViewController(url: myUrl, configuration: config)
            vc.preferredBarTintColor = UIColor(cgColor: #colorLiteral(red: 0.2117426097, green: 0.2117787898, blue: 0.2117346823, alpha: 1))
            vc.preferredControlTintColor = .white
            vc.modalPresentationStyle = .formSheet
            safariServicesHandler?(vc)
        }
    }
}
