//
//  OnBoardingViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 23/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    var viewModel: OnBoardingViewModel!

    private lazy var textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()

    private lazy var introLabelFirst: UILabel = {
        let label =  UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Argon PERSONAL", size: 70)
        label.text = "R"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var introLabelMiddle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Les meilleures radios et podcasts sur"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var introLabelLast: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Radiofy."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.heightAnchor.constraint(equalToConstant: 15).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.loadViewIfNeeded()
//    }

//    @IBAction private func signUpButtonTapped(_ sender: Any) {
//        viewModel.openSignUpView()
//    }
//
//    @IBAction private func logInButtonTapped(_ sender: Any) {
//        viewModel.openLogInView()
//    }
//
//    @IBAction func skipRegistration(_ sender: Any) {
//        viewModel.signInAnonymously()
//    }
}

private extension OnBoardingViewController {

    func configureView() {
        view.addSubview(textContainer)
        view.addSubview(buttonContainer)

        textContainer.addArrangedSubview(introLabelFirst)
        textContainer.addArrangedSubview(introLabelMiddle)
        textContainer.addArrangedSubview(introLabelLast)

        buttonContainer.addArrangedSubview(signUpButton)
        buttonContainer.addArrangedSubview(loginButton)
        buttonContainer.addArrangedSubview(skipButton)

        let safeView = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textContainer.topAnchor.constraint(equalTo: safeView.topAnchor, constant: 0),
            textContainer.leftAnchor.constraint(equalTo: safeView.leftAnchor),
            textContainer.rightAnchor.constraint(equalTo: safeView.rightAnchor),
            textContainer.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -70),

            buttonContainer.leftAnchor.constraint(equalTo: safeView.leftAnchor),
            buttonContainer.rightAnchor.constraint(equalTo: safeView.rightAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: safeView.bottomAnchor, constant: -70),

            signUpButton.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor, constant: 40),
            signUpButton.rightAnchor.constraint(equalTo: buttonContainer.rightAnchor, constant: -40),

            loginButton.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor, constant: 40),
            loginButton.rightAnchor.constraint(equalTo: buttonContainer.rightAnchor, constant: -40)
        ])
    }

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
    }
}

extension OnBoardingViewController: Storyboarded {}
