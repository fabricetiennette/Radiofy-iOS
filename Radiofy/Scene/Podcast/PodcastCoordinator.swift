//
//  PodcastCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class PodcastCoordinator {

    // MARK: - Properties

    let navigationController = UINavigationController()

    // MARK: - Coordinator

    func start() {
        let viewController = PodcastViewController.instantiate(from: "Podcast")
        let viewModel = PodcastViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.tabBarItem = UITabBarItem(
            title: "Podcast",
            image: UIImage(named: "podcastsLogo"),
            selectedImage: UIImage(named: "podcastsFilled")
        )
        navigationController.viewControllers = [viewController]
    }

    func makePodcasListView(_ selectedPodcast: PodcastStation) {
        let viewController = PodcastListViewController.instantiate(from: "Podcast")
        let viewModel = PodcastListViewModel(
            delegate: self,
            selectedPodcastStation: selectedPodcast
        )
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    func makeEpisodeView(with podcastEpisode: Podcast) {
        let viewController = EpisodeViewController.instantiate(from: "Podcast")
        let viewModel = EpisodeViewModel(delegate: self, selectedPodcast: podcastEpisode)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makePayWallView() {
        let viewController = SubscriptionViewController.instantiate(from: "Subscription")
        let viewModel = SubscriptionViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }

    private func makeSignUpView() {
        let viewController = SignUpViewController.instantiate(from: "Start")
        let viewModel = SignUpViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.creatAccount
        navigationController.pushViewController(viewController, animated: true)
    }

    private func launchHomeView() {
        let main = MainTabBarController()
        let radioPlayer = RadioPlayerCoordinator(tabBarController: main)
        navigationController.view.window?.rootViewController = main
        navigationController.view.window?.makeKeyAndVisible()
        radioPlayer.start()
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
    func callhomeScreen() {
        launchHomeView()
    }
}
