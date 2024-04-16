//
//  LaunchViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

final class LaunchViewController: UIViewController {

    private var viewModel: LaunchModule.ViewModel

    private lazy var radiofyLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "Radiofy")
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()

    init(viewModel: LaunchModule.ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @objc private func showStartAfterSignOut(notification: Notification) {
        viewModel.isUserLoggedIn()
    }
}

private extension LaunchViewController {

    func onViewDidLoad() {
        addObserver()
        viewModel.setupEmailLanguage()
        startAnimation()
    }

    func startAnimation() {
        switch viewModel.isOn {
        case true:
            slideInLogoFromTop()
        case false:
            viewModel.isUserLoggedIn()
        }
    }

    func addObserver() {
//       NotificationCenter.default.addObserver(self, selector: #selector(showStartAfterSignOut(notification:)), name: SettingsViewModel.NotificationDone, object: nil)
   }

    func slideInLogoFromTop() {
        // Add Logo to view and constraint
        view.addSubview(radiofyLogo)
        NSLayoutConstraint.activate([
            radiofyLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            radiofyLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            radiofyLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            radiofyLogo.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Add animation
        let transition = CATransition()
        transition.duration = 2.0
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.delegate = self
        transition.type = .push
        transition.subtype = .fromBottom
        radiofyLogo.layer.add(transition, forKey: kCATransition)
    }
}

extension LaunchViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        viewModel.isUserLoggedIn()
    }
}

class CombineMessageReceiver {
    private var cancelSet: Set<AnyCancellable> = []

    init(_ publisher: AnyPublisher<Void?, Never>) {
        publisher
            .sink { _ in }
            .store(in: &cancelSet)
    }
}
