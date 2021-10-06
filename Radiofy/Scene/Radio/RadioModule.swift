//
//  RadioModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 02/10/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

struct RadioModule {

    typealias ViewModel = RadioModuleOutputBinding & RadioModuleInputBinding
    typealias CoordinatorDelegate = RadioModuleViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?
    private var radio: RadioStation

    init(coordinatorDelegate: CoordinatorDelegate?, radio: RadioStation) {
        self.coordinatorDelegate = coordinatorDelegate
        self.radio = radio
    }

    var viewController: UIViewController {
        let viewModel = RadioViewModel(radio: radio)
        let radioViewController = RadioViewController.instantiate(from: .radio)
        radioViewController.viewModel = viewModel
        viewModel.delegate = coordinatorDelegate
        return radioViewController
    }
}

protocol RadioModuleOutputBinding {
    var radioDetailsSubject: PassthroughSubject<RadioStation, Never> { get set }
}

protocol RadioModuleInputBinding {
    var isRadioFavorite: Bool { get }

    func deleteFromUserDefaults()
    func saveToUserDefaults()
    func playRadio()
    func showRadioDetails()
}

protocol RadioModuleViewModelDelegate: AnyObject {
    func openPayWallView()
}
