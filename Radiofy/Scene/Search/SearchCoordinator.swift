//
//  SearchCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

protocol SearchCoordinatorDelegate: CoordinatorDelegate {
    func didSelectRadio(_ selectedradio: RadioStation)
}

final class SearchCoordinator: Coordinator<UINavigationController> {

    // MARK: - Properties

    enum Options {
        case present(UINavigationController, style: UIModalPresentationStyle)
        case push(UINavigationController)
    }

    private let options: Options

    init(options: Options) {
        self.options = options
        switch options {
        case let .present(viewController, style: _):
            super.init(rootView: viewController)
        case let .push(navigationController):
            super.init(rootView: navigationController)
        }
    }

    weak var delegate: SearchCoordinatorDelegate?

        // MARK: - Coordinator

    override func start() {
        let module = SearchModule(coordinatorDelegate: self)
        let searchViewController = module.viewController

        switch self.options {
        case let .present(vc, style):
            let navigationController = UINavigationController(rootViewController: searchViewController)
            navigationController.modalPresentationStyle = style
            vc.present(navigationController, animated: true)
        case let .push(navigationController):
            navigationController.pushViewController(searchViewController, animated: true)
        }
    }

    // Make radio profile page
    private func makeRadioPage(with selectedRadio: RadioStation) {
        let viewController = RadioViewController.instantiate(from: .radio)
        let viewModel = RadioViewModel(delegate: self, selectedRadio: selectedRadio)
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }
}

extension SearchCoordinator: SearchViewModelDelegate {
    func selectRadio(_ selectedradio: RadioStation) {
        delegate?.didSelectRadio(selectedradio)
    }
}

extension SearchCoordinator: RadioViewModelDelegate {
    func openPayWallView() {}
}
