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

    @objc private func showStartAfterSignOut(notification: Notification) {
        viewModel.isUserLoggedIn()
    }
}

private extension LaunchViewController {

    func onViewDidLoad() {
        view.backgroundColor = .red
        addObserver()
        viewModel.isUserLoggedIn()
        viewModel.setupEmailLanguage()
    }

    func addObserver() {
       NotificationCenter.default.addObserver(self, selector: #selector(showStartAfterSignOut(notification:)), name: SettingsViewModel.NotificationDone, object: nil)
   }
}
