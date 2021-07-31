//
//  SignUpViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var signUpButton: SignMeUpButtonView!
    @IBOutlet private weak var signUpButtonWidth: NSLayoutConstraint!

    private var buttonContraint = [NSLayoutConstraint]()
    private var disposeBag: Set<AnyCancellable> = []
    var viewModel: SignUpModule.ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonContraint = signUpButton.constraints
    }

    @objc private func tapView() {
        viewEndEditing()
    }

    @objc private func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        errorTextLabel.slideOut()
        guard
            let name = nameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else
        {
            signUpButton.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.3018799424, green: 0.3020585179, blue: 0.2976047993, alpha: 1))
            signUpButton.isEnabled = false
            return
        }
        signUpButton.backgroundColor = .white
        signUpButton.isEnabled = true
    }

    @IBAction private func textFieldTapped(_ sender: UITextField) {
        sender.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.4382694662, green: 0.443403244, blue: 0.4388435185, alpha: 1))
        switch sender.tag {
        case 1:
            emailTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
            passwordTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
        case 2:
            nameTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
            passwordTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
        case 3:
            nameTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
            emailTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
        default: break
        }
    }
}

private extension SignUpViewController {

    func setupBindings() {

        // SignUpButton Tapped
        signUpButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewEndEditing()

                let name = self.nameTextField.text
                let email = self.emailTextField.text
                let password = self.passwordTextField.text

                self.viewModel?.signUpOneUser(name, email, password)
            }
            .store(in: &disposeBag)

        // BackButton Tapped
        let backButton = UIBarButtonItem(title: L1s.back,
                                         style: .plain,
                                         cancellables: &disposeBag,
                                         action: { self.viewModel?.tapBack() })
        navigationItem.leftBarButtonItem = backButton
    }

    func configureViewModel() {
        guard let viewModel = self.viewModel else { return }

        viewModel
            .errorSubject
            .sink(receiveValue: { [weak self] message in
                guard let self = self else { return }
                if self.errorTextLabel.text != message {
                    self.errorTextLabel.slideInFromBottom()
                }
                self.errorTextLabel.text = message
                self.errorTextLabel.alpha = 1
                self.signUpButton.animateWhileAwaitingResponse(
                    showLoading: false,
                    originalConstraints: self.buttonContraint,
                    identifier: "signUpButtonWidth",
                    title: L1s.signUp
                )
            }).store(in: &disposeBag)

        viewModel
            .spinnerSubject
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.signUpButton.animateWhileAwaitingResponse(
                    showLoading: true,
                    originalConstraints: self.signUpButton.constraints,
                    identifier: "signUpButtonWidth",
                    title: L1s.signUp
                )
            }).store(in: &disposeBag)
    }

    func configureView() {
        errorTextLabel.alpha = 0
        nameTextField.becomeFirstResponder()
        signUpButtonWidth.constant = UIScreen.main.bounds.width -
            (UIScreen.main.bounds.width - signUpButton.frame.width )
        signUpButton.isEnabled = false
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapView)))
        [nameTextField, emailTextField, passwordTextField]
            .forEach { $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)}
    }

    func viewEndEditing() {
        view.endEditing(true)
        textFieldNotFocus()
    }

    func textFieldNotFocus() {
        [nameTextField, emailTextField, passwordTextField]
            .forEach { $0.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1)) }
    }
}

extension SignUpViewController: Storyboarded {}
