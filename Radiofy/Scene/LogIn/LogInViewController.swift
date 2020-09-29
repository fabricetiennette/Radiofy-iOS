//
//  SignInViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var logInButton: FinalLogInButtonView!
    @IBOutlet private weak var logInButtonWidth: NSLayoutConstraint!

    private var buttonContraint = [NSLayoutConstraint]()
    var viewModel: LogInViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadView()
        makeTextFieldFocus()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLogInButton()
        buttonContraint = logInButton.constraints
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
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else
        {
            logInButton.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.3018799424, green: 0.3020585179, blue: 0.2976047993, alpha: 1))
            logInButton.isEnabled = false
            return
        }
        logInButton.backgroundColor = .white
        logInButton.isEnabled = true
    }

    @IBAction private func logInButtonTapped(_ sender: Any) {
        viewEndEditing()

        let email = emailTextField.text
        let password = passwordTextField.text

        viewModel.logInUser(with: email, password)
    }

    @IBAction private func forgettenPasswordButtonTapped(_ sender: Any) {
        viewEndEditing()

        viewModel.launchingPasswordReset()
    }

    @IBAction private func textFieldTapped(_ sender: UITextField) {
        sender.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.4382694662, green: 0.443403244, blue: 0.4388435185, alpha: 1))

        switch sender.tag {
        case 1:
            passwordTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
        case 2:
            emailTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
        default: break
        }
    }
}

private extension LogInViewController {

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] message in
            guard let me = self else { return }
            if me.errorTextLabel.text != message {
                me.errorTextLabel.slideInFromBottom()
            }
            me.errorTextLabel.text = message
            me.errorTextLabel.alpha = 1
            me.logInButton.animateWhileAwaitingResponse(
                showLoading: false,
                originalConstraints: me.buttonContraint,
                identifier: "logInButtonWidth",
                title: L1s.logIn
            )
        }

        viewModel.spinnerHandler = { [weak self] in
            guard let me = self else { return }
            me.logInButton.animateWhileAwaitingResponse(
                showLoading: true,
                originalConstraints: me.logInButton.constraints,
                identifier: "logInButtonWidth",
                title: L1s.logIn
            )
        }
    }

    func configureView() {
        errorTextLabel.alpha = 0
        logInButtonWidth.constant = UIScreen.main.bounds.width -
        (UIScreen.main.bounds.width - logInButton.frame.width )
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }

    func configureLogInButton() {
         logInButton.isEnabled = false
        [emailTextField, passwordTextField]
        .forEach { $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)}
    }

    func makeTextFieldFocus() {
        errorTextLabel.alpha = 0
        emailTextField.becomeFirstResponder()
        emailTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.4382694662, green: 0.443403244, blue: 0.4388435185, alpha: 1))
    }

    func viewEndEditing() {
        view.endEditing(true)
        textFieldNotFocus()
    }

    func textFieldNotFocus() {
           [emailTextField, passwordTextField]
               .forEach { $0.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1)) }
       }
}
