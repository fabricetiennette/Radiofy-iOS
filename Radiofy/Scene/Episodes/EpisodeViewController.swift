//
//  EpisodeViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMobileAds

class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTableView: UITableView!

    private lazy var episodeDataSource = EpisodeDataSource()
    var viewModel: EpisodeViewModel!
    var interstitial = GADInterstitial(adUnitID: "ca-app-pub-2776074318440444/1196771955")
    private var episode: Episode!

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        episodeTableView.delegate = episodeDataSource
        episodeTableView.dataSource = episodeDataSource

        configureNavbar()
        configureAdMob()

        bind(to: viewModel)
        bindViewModel(to: episodeDataSource)
    }
}

private extension EpisodeViewController {

    func bind(to viewModel: EpisodeViewModel) {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.stopAnimating()
            me.showAlert(title: title, message: message)
        }
        viewModel.episodeHandler = { [weak self] allEpisode in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.episodeDataSource.updateCell(with: allEpisode)
                me.episodeTableView.reloadData()
                me.stopAnimating()
            }
        }
        viewModel.getEpisode()
    }

    func bindViewModel(to dataSource: EpisodeDataSource) {
        dataSource.episodeTapHandler = { [weak self] episode in
            guard let me = self else { return }
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            let current = formatter.string(from: currentDate)
            let date = UserDefaultConfig.blockingTime
            if current > date || HomeViewController.isUserPremium == true {
                if me.interstitial.isReady {
                    me.episode = episode
                    me.interstitial.present(fromRootViewController: me)
                } else {
                    me.viewModel.getAndPlayEpisode(with: episode)
                }
            } else {
                me.showAlertAndGoPremium(
                    title: L1s.limitReached,
                    message: L1s.limitMessage,
                    submitTitle: L1s.goPremium,
                    cancelTitle: L1s.cancelButton
                ) {
                    me.viewModel.showPayWall()
                }
            }
        }
    }
}

private extension EpisodeViewController {

    func startAnimation() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballBeat, color: .white, fadeInAnimation: nil)
    }

    func configureNavbar() {
        guard let navigationController = navigationController else { return }
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationItem.standardAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationItem.scrollEdgeAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.title = viewModel.selectedPodcast?.trackName
        } else {
            navigationController.navigationBar.titleTextAttributes = [
                           NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.title = viewModel.selectedPodcast?.trackName
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
            bannerView.adUnitID = "ca-app-pub-2776074318440444/9981149535"
            interstitial = createAndLoadInterstitial()
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }

    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2776074318440444/1196771955")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
}

extension EpisodeViewController: GADInterstitialDelegate {
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        viewModel.getAndPlayEpisode(with: episode)
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
}

extension EpisodeViewController: Storyboarded, NVActivityIndicatorViewable {}
