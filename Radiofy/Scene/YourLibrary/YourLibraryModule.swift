//
//  YourLibraryModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 17/10/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

struct YourLibraryModule {

    typealias ViewModel = YourLibraryModuleOutputBinding & YourLibraryModuleInputBinding
    typealias CoordinatorDelegate = YourLibraryModuleViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?

    init(coordinatorDelegate: CoordinatorDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let viewModel = YourLibraryViewModel()
        let radioViewController = YourLibraryViewController(viewModel: viewModel)
        viewModel.delegate = coordinatorDelegate
        return radioViewController
    }
}

protocol YourLibraryModuleOutputBinding {
    var favorite: [RadioStation] { get }
    var messageSubject: PassthroughSubject<String, Never> { get set }

    func getFavoritesRadioStations()
}

protocol YourLibraryModuleInputBinding {
    func showSelectedRadioPage(with selectedRadio: RadioStation)
}

protocol YourLibraryModuleViewModelDelegate: AnyObject {
    func selectRadio(_ selectedradio: RadioStation)
}
