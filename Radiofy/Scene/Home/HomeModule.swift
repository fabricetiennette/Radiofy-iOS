//
//  HomeModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/06/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

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

}

protocol HomeOutputBinding {
    
}

protocol HomeServiceProtocol {
    func saveDocumentToDatabase(imageUrl: String, mainColor: String, name: String, streamUrl: String)
    func getStationDetails(with collectionName: String, callback: @escaping (Result<[RadioStation], Error>) -> Void)
    func isFullAppAccessAuthorized(callback: @escaping (Result<Bool, Error>) -> Void)
}

protocol HomeViewModelDelegate: AnyObject {
    func launchSettings()
    func showSelectedRadio(_ selectedRadio: RadioStation)
    func showPayWall()
}
