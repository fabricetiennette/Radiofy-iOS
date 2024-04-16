//
//  OnBoardingViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 23/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

final class OnBoardingViewController: UIViewController {

    private var viewModel: OnBoardingModule.ViewModel
    private var disposeBag = Set<AnyCancellable>()

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
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 1
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.layer.borderColor = UIColor.lightText.cgColor
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.greenMain.color
        button.setTitle("SIGN UP", for: .normal)
        button.layer.cornerRadius = 24
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("SKIP FOR NOW", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .clear
        button.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 15).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(viewModel: OnBoardingModule.ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupBindings()
    }
}

    // MARK: - Private Extension

private extension OnBoardingViewController {

    func setupBindings() {

        // Sign up Button
        signUpButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didTapSignUp()
            }
            .store(in: &disposeBag)

        // Login Button
        loginButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didTapLogIn()
            }
            .store(in: &disposeBag)

        // Skip Button
        skipButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didTapSignInAnonymously()
            }
            .store(in: &disposeBag)

        // Send Error if needed
        viewModel.errorSubject
            .sink { [weak self] title, message in
                guard let self = self else { return }
                self.showAlert(title: title, message: message)
            }
            .store(in: &disposeBag)
    }

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
}

extension OnBoardingViewController: Storyboarded {}
