//
//  SettingsModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 31/07/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine
import Firebase
import FirebaseStorage

struct SettingsModule {

    typealias ViewModel = SettingsOutputBinding & SettingsInputBinding
    typealias Service = SettingsServiceProtocol
    typealias CoordinatorDelegate = SettingsViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?

    init(coordinatorDelegate: CoordinatorDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let service = SettingsService()
        let viewModel = SettingsViewModel(service: service)
        let settingsViewController = SettingsViewController.instantiate(from: .home)
        viewModel.delegate = coordinatorDelegate
        settingsViewController.viewModel = viewModel
        return settingsViewController
    }
}

protocol SettingsOutputBinding {
    func getUserName()
    func isUserLoggedIn()
    func removeListener()
    func getUserProfilePhotoReference()
    var errorSubject: PassthroughSubject<(String, String), Never> { get set }
    var userNameSubject: PassthroughSubject<String, Never> { get set }
    var refSubject: PassthroughSubject<StorageReference, Never> { get set }
    var userIsNotAnonymousSubject: PassthroughSubject<Void, Never> { get set }
}

protocol SettingsInputBinding {
    func signOutUser()
    func showOrCreateProfileView()
    func showAccountView()
    func showAboutView()
}

protocol SettingsServiceProtocol {
    var currentUser: User? { get }
    var userEmail: String? { get }
    var isAnonymous: Bool { get }
    func removeListener()
    func userStorageReference(email: String) -> AnyPublisher<StorageReference, Never>
    func getUserName(email: String) -> AnyPublisher<String, Error>
    func stateDidChangeForAuth() -> AnyPublisher<Void, Never>
    func signOutUser() -> AnyPublisher<Void, Error>
}

protocol SettingsViewModelDelegate: AnyObject {
    func editProfile()
    func accountPage()
    func aboutPage()
    func createAccount()
}

protocol SettingsCoordinatorDelegate: CoordinatorDelegate {
    func goToCreateAccount()
    func goToAccountPage()
    func goToAboutPage()
    func goToEditProfile()
}
