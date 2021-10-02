//
//  SearchModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 26/09/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

struct SearchModule {

    typealias ViewModel = SearchOutputBinding & SearchInputBinding
    typealias CoordinatorDelegate = SearchViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?

    init(coordinatorDelegate: CoordinatorDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController.instantiate(from: .search)
        viewModel.delegate = coordinatorDelegate
        searchViewController.viewModel = viewModel
        return searchViewController
    }
}

protocol SearchInputBinding {
//    func signUpOneUser(_ nameTextField: String?, _ emailTextField: String?, _ passwordTextField: String?)
//    func tapBack()
}

protocol SearchOutputBinding {
//    var errorSubject: PassthroughSubject<String, Never> { get set }
//    var spinnerSubject: PassthroughSubject<Void, Never> { get set }
}

protocol SearchViewModelDelegate: AnyObject {
    func selectRadio(_ selectedradio: RadioStation)
}
