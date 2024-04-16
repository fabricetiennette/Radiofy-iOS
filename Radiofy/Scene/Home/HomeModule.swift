//
//  HomeModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/06/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

final class HomeModule {

    typealias ViewModel = HomeInputBinding & HomeOutputBinding
    typealias Service = HomeServiceProtocol
    typealias CoordinatorDelegate = HomeViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?

    init(coordinatorDelegate: CoordinatorDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let service = HomeService()
        let viewModel = HomeViewModel(service: service)
        let homeViewController = HomeViewController.instantiate(from: .home)
        viewModel.delegate = coordinatorDelegate
        homeViewController.viewModel = viewModel
        return homeViewController
    }
}

protocol HomeInputBinding {
    func launchSettingsPage()
    func showSelectedRadioPage(with selectedRadio: RadioStation)
}

protocol HomeOutputBinding {
    func verifiedAndFetchRadioStations()
    func getRecentlyPlayedStationsDetails()
    var errorSubject: PassthroughSubject<(String, String), Never> { get set }
    var recentlyPlayedSubject: PassthroughSubject<[RadioStation], Never> { get set }
    var popularSubject: PassthroughSubject<[RadioStation], Never> { get set }
    var nationalSubject: PassthroughSubject<[RadioStation], Never> { get set }
    var headerSubject: PassthroughSubject<[RadioStation], Never> { get set }
}

protocol HomeServiceProtocol {
    func saveDocumentToDatabase(imageUrl: String, mainColor: String, name: String, streamUrl: String)
    func getStationDetails(with collectionName: String) -> AnyPublisher<[RadioStation], Error>
    func isFullAppAccessAuthorized() -> AnyPublisher<Bool, Error>
}

protocol HomeViewModelDelegate: AnyObject {
    func launchSettings()
    func showSelectedRadio(_ selectedRadio: RadioStation)
    func showPayWall()
}
