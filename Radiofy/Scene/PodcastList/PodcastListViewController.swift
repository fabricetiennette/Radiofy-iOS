//
//  PodcastListViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PodcastListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!

    private lazy var podcastListDataSource = PodcastListDataSource()
    var viewModel: PodcastListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = podcastListDataSource
        listTableView.dataSource = podcastListDataSource

        bind(to: viewModel)
        bindViewModel(to: podcastListDataSource)

        configureNavbar()
        configureAdMob()
    }
}

private extension PodcastListViewController {

    func bind(to viewModel: PodcastListViewModel) {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
        viewModel.podcastServiceHandler = { [weak self] podcasts in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.podcastListDataSource.updateCell(with: podcasts)
                me.listTableView.reloadData()
            }
        }
    }

    func bindViewModel(to dataSource: PodcastListDataSource) {
        dataSource.podcastTapHandle = { [weak self] podcastSelected in
            guard let me = self else { return }
            me.viewModel.showEpisodeView(with: podcastSelected)
        }
    }
}
private extension PodcastListViewController {
    func configureNavbar() {
        guard let navigationController = navigationController else { return }
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationItem.standardAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationItem.scrollEdgeAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.title = viewModel.title
        } else {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.title = viewModel.title
        }
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view.safeAreaLayoutGuide,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }

    func configureAdMob() {
        if HomeViewController.isUserPremium == false {
            let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = "ca-app-pub-2776074318440444/3415741188"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
}
extension PodcastListViewController: Storyboarded {}
