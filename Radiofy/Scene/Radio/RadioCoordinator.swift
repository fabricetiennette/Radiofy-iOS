//
//  RadioCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 02/10/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

protocol RadioCoordinatorDelegate: CoordinatorDelegate {
    func getSelectedRadioStation(_ radioStation: RadioStation)
}

final class RadioCoordinator: Coordinator<UIViewController> {

    // MARK: - Properties

    enum Options {
        case present(UINavigationController, style: UIModalPresentationStyle)
        case push(UINavigationController)
    }

    private let options: Options
    private let radio: RadioStation

    init(options: Options, radio: RadioStation) {
        self.options = options
        self.radio = radio
        switch options {
        case let .present(viewController, style: _):
            super.init(rootView: viewController)
        case let .push(navigationController):
            super.init(rootView: navigationController)
        }
    }

    weak var delegate: RadioCoordinatorDelegate?

    override func start() {
        let module = RadioModule(coordinatorDelegate: self, radio: radio)
        let radioViewController = module.viewController

        switch options {
        case let .present(viewController, style: style):
            let navigationController = UINavigationController(rootViewController: radioViewController)
            navigationController.modalPresentationStyle = style
            viewController.present(radioViewController, animated: true)

        case let .push(navigationController):
            navigationController.pushViewController(radioViewController, animated: true)
        }
    }
}

extension RadioCoordinator: RadioModuleViewModelDelegate {
    func openPayWallView() {}
}
