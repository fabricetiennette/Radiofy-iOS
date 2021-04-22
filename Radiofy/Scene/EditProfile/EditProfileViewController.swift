//
//  EditProfileViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 04/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorViewExtended

class EditProfileViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var errorTextLabel: UILabel!

    private var isRemovingCurrentPhotoAvailable = false
    private var isSavingButtonAvailable = false
    private var imageUrl = ""
    var viewModel: EditProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureView()
        configureViewModel()
    }

    @objc private func tapView() {
        view.endEditing(true)
    }

    @objc private func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func saveTapped() {
        startAnimation()
        let image =  userImageView.image?.jpegData(compressionQuality: 0.25)
        let userName = userNameTextField.text.clearedText()
        viewModel.saveUserInfo(image, userName)
    }

   @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        showImagePickerControllerActionSheet()
    }

    @IBAction private func changePhotoTapped(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }

    @IBAction private func nameTextChanged(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

private extension EditProfileViewController {

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] errorText in
            guard let me = self else { return }
            me.stopAnimating()
            me.errorTextLabel.slideInFromBottom()
            me.errorTextLabel.textColor = .red
            me.errorTextLabel.text = errorText
        }
        viewModel.successHandler = { [weak self] in
            guard let me = self else { return }
            me.errorTextLabel.textColor = .lightText
            me.errorTextLabel.text = L1s.editNickname
            me.stopAnimating()
            me.dismiss(animated: true, completion: nil)
        }
        viewModel.userHandler = { [weak self] name, photoUrl in
            guard let me = self else { return }
            me.imageUrl = photoUrl
            me.userImageView.getImage(from: photoUrl)
            me.userNameTextField.text = name
        }
        viewModel.getUserInfoToEdit()
    }

    func configureView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))

        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderColor? = UIColor.clear.cgColor
        userImageView.layer.borderWidth = 1
        userImageView.isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    func startAnimation() {
        errorTextLabel.textColor = .lightText
        errorTextLabel.text = L1s.editNickname
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballBeat, color: .white, fadeInAnimation: nil)
    }

    func configureNavigationController() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.09802495688, green: 0.09804918617, blue: 0.09802179784, alpha: 1))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = L1s.editProfil

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: L1s.cancel, style: .plain, target: self, action: #selector(cancelTapped))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L1s.save, style: .done, target: self, action: #selector(saveTapped))

        navigationItem.leftBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .highlighted)

        navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .highlighted)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .disabled)

        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func showImagePickerControllerActionSheet() {

        let photoLibraryAction =
            UIAlertAction(title: L1s.chooseFromLibrary, style: .default) { _ in
            self.changeUserPhoto(sourceType: .photoLibrary)
        }

        let cameraAction =
            UIAlertAction(title: L1s.takePhoto, style: .default) { _ in
            self.changeUserPhoto(sourceType: .camera)
        }

        let removeAction = UIAlertAction(title: L1s.deleteLastPhoto, style: .default) { _ in
            self.isRemovingCurrentPhotoAvailable = false
            self.userImageView.getImage(from: self.imageUrl)
        }
        removeAction.isEnabled = isRemovingCurrentPhotoAvailable

        let cancelAction =
            UIAlertAction(title: L1s.cancel, style: .cancel, handler: nil)

        self.showAlertWithAction(
            style: .actionSheet,
            title: L1s.changeProfilAlert,
            message: nil,
            actions: [photoLibraryAction, cameraAction, removeAction, cancelAction],
            completion: nil
        )
    }

    private func changeUserPhoto(sourceType: UIImagePickerController.SourceType) {
        // Create an imagePicker and provide it a delegate of UIImagePickerController
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = editedImage
            isRemovingCurrentPhotoAvailable = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = originalImage
            isRemovingCurrentPhotoAvailable = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }

        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: Storyboarded, NVActivityIndicatorViewable {}
