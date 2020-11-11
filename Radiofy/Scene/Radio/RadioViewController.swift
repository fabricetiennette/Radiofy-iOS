//
//  RadioViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class RadioViewController: UIViewController {

    @IBOutlet private weak var radioImageView: UIImageView!
    @IBOutlet private weak var radioLabel: UILabel!
    @IBOutlet private weak var radioMagicView: UIView!

    var viewModel: RadioViewModel!

    private let favoriteBtn = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        configureViewModel()
        addFavoriteButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
}

extension RadioViewController {

    @objc func favoriteButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            viewModel.deleteFromUserDefaults()
        } else {
            viewModel.saveToUserDefaults()
        }
        sender.isSelected = (sender.isSelected == true) ? false : true
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        viewModel.playRadio()
    }
}

extension RadioViewController: Storyboarded {}

private extension RadioViewController {

    func configureViewModel() {
        viewModel.radioDetailsHandler = { [weak self] radioSelected in
            guard let me = self,
                let url = URL(string: radioSelected.imageURL) else { return }
            me.radioImageView.sd_setImage(with: url, completed: nil)
            me.radioMagicView.setBackgourndColorWithGradient(
                colorHead: radioSelected.color,
                colorCenter: #colorLiteral(red: 0.07057782263, green: 0.07059488446, blue: 0.07057409734, alpha: 1),
                colorBottom: #colorLiteral(red: 0.07057782263, green: 0.07059488446, blue: 0.07057409734, alpha: 1)
            )
            me.radioLabel.text = radioSelected.name
            me.navigationItem.title = radioSelected.name
        }
        if viewModel.isRadioFavorite() {
            favoriteBtn.isSelected = true
        }
        viewModel.showRadioDetails()
    }
}

private extension RadioViewController {

    func configureView() {
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    func addFavoriteButton() {
        favoriteBtn.accessibilityIdentifier = "favoriteBtnItem"
        favoriteBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        favoriteBtn.setImage(UIImage(named: "heartIcon"), for: .normal)
        favoriteBtn.setImage(UIImage(named: "heartIconFill"), for: .selected)
        favoriteBtn.addTarget(
            self,
            action: #selector(favoriteButtonTapped(_:)),
            for: .touchUpInside
        )

        let favoriteBtnItem = UIBarButtonItem(customView: favoriteBtn)
        let currWidth = favoriteBtnItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = favoriteBtnItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        navigationItem.rightBarButtonItem = favoriteBtnItem
    }
}
