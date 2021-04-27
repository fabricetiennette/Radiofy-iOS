//
//  LaunchViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

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
        slideInLogoFromTop()
    }

    func addObserver() {
       NotificationCenter.default.addObserver(self, selector: #selector(showStartAfterSignOut(notification:)), name: SettingsViewModel.NotificationDone, object: nil)
   }

    func setupLogo() {
        view.addSubview(radiofyLogo)
        NSLayoutConstraint.activate([
            radiofyLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            radiofyLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            radiofyLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            radiofyLogo.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func slideInLogoFromTop() {
        setupLogo()
        let transition = CATransition()
        let timmingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        transition.duration = 1.5
        transition.timingFunction = timmingFunction
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        radiofyLogo.layer.add(transition, forKey: kCATransition)

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.5 * 1.4
        ) {
            self.viewModel.isUserLoggedIn()
        }
    }
}
