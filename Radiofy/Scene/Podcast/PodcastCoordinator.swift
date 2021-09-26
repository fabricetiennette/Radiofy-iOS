//
//  PodcastCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class PodcastCoordinator: Coordinator<UINavigationController> {

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

    // MARK: - Coordinator

    override func start() {
        let viewController = PodcastViewController.instantiate(from: .podcast)
        let viewModel = PodcastViewModel(delegate: self)
        viewController.viewModel = viewModel

        switch self.options {
        case let .present(vc, style):
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = style
            vc.present(navigationController, animated: true)
        case let .push(navigationController):
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func makePodcasListView(_ selectedPodcast: PodcastStation) {
        let viewController = PodcastListViewController.instantiate(from: .podcast)
        let viewModel = PodcastListViewModel(
            delegate: self,
            selectedPodcastStation: selectedPodcast
        )
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    func makeEpisodeView(with podcastEpisode: Podcast) {
        let viewController = EpisodeViewController.instantiate(from: .podcast)
        let viewModel = EpisodeViewModel(delegate: self, selectedPodcast: podcastEpisode)
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func makePayWallView() {
        let viewController = SubscriptionViewController.instantiate(from: .subscription)
        let viewModel = SubscriptionViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        rootView.present(viewController, animated: true, completion: nil)
    }

    private func makeSignUpView() {
//        let viewController = SignUpViewController.instantiate(from: "Start")
//        let viewModel = SignUpViewModel(delegate: self)
//        viewController.viewModel = viewModel
//        viewController.navigationItem.title = L10n.createAccount
//        rootView.pushViewController(viewController, animated: true)
    }

    private func launchHomeView() {
//        let rootView = UITabBarController()
//        let main = MainTabBarController(rootView: rootView)
//        let radioPlayer = RadioPlayerCoordinator(rootView: main)
//        navigationController.view.window?.rootViewController = main
//        navigationController.view.window?.makeKeyAndVisible()
//        radioPlayer.start()
    }
}

extension PodcastCoordinator: PodcastViewModelDelegate {
    func selectPocastStation(_ selectedPodcast: PodcastStation) {
        makePodcasListView(selectedPodcast)
    }
}

extension PodcastCoordinator: PodcastListViewModelDelegate {
    func showSelectedPodcastEpisode(_ selectedEpisode: Podcast) {
        makeEpisodeView(with: selectedEpisode)
    }
}

extension PodcastCoordinator: EpisodeViewModelDelegate {
    func payWallView() {
        makePayWallView()
    }
}

extension PodcastCoordinator: SubscriptionViewModelDelegate {
    func signUpFirst() {
        makeSignUpView()
    }
}

extension PodcastCoordinator: SignUpViewModelDelegate {
    func didTapOnBack() {

    }

    func goToHomeView() {
        launchHomeView()
    }
}
