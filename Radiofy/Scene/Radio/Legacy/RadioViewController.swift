//
//  RadioViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

//import UIKit
//import SDWebImage
//import Combine
//
//final class RadioViewController: RadiofyViewController<RadioModule.ViewModel> {
//
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [radioImageView, radioLabel, playButton])
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 40
//        stackView.alignment = .center
//        stackView.axis = .vertical
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    private lazy var radioImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private lazy var radioLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.font = .systemFont(ofSize: 25, weight: .semibold)
//        label.textColor = .white
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private lazy var playButton: ButtonRadioView = {
//        let button = ButtonRadioView()
//        button.backgroundColor = Asset.radiofyGreen.color
//        button.setTitle(L10n.play, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
//        button.titleLabel?.textColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private let favoriteBtn = UIButton(type: .custom)
//    private var disposeBag: Set<AnyCancellable> = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupInterface()
//        setupConstraints()
//        configureViewModel()
//        addFavoriteButton()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        configureView()
//    }
//}
//
//extension RadioViewController {
//
//    @objc func favoriteButtonTapped(_ sender: UIButton) {
//        if sender.isSelected {
//            viewModel.deleteFromUserDefaults()
//        } else {
//            viewModel.saveToUserDefaults()
//        }
//        sender.isSelected = (sender.isSelected == true) ? false : true
//    }
//}
//
//private extension RadioViewController {
//
//    func configureViewModel() {
//        playButton
//            .publisher(for: .touchUpInside)
//            .sink(receiveValue: { [weak self] _ in
//                guard let self = self else { return }
//                self.viewModel.playRadio()
//            })
//            .store(in: &disposeBag)
//
//        viewModel
//            .radioDetailsSubject
//            .sink(receiveValue: { [weak self] radioSelected in
//                guard let me = self,
//                      let url = URL(string: radioSelected.imageURL) else { return }
//                me.radioImageView.sd_setImage(with: url,
//                                              placeholderImage: Asset.noPicture.image)
//                me.view.setBackgourndColorWithGradient(colorHead: radioSelected.color,
//                                                       colorCenter: Asset.darkSlateColor.color,
//                                                       colorBottom: Asset.darkSlateColor.color)
//                me.radioLabel.text = radioSelected.name
//                me.navigationItem.title = radioSelected.name
//            })
//            .store(in: &disposeBag)
//
//        if viewModel.isRadioFavorite {
//            favoriteBtn.isSelected = true
//        }
//        viewModel.showRadioDetails()
//    }
//}
//
//private extension RadioViewController {
//
//    func setupInterface() {
//        navigationItem.largeTitleDisplayMode = .never
//        view.backgroundColor = Asset.backgroundColor.color
//
//        view.addSubview(stackView)
//    }
//
//    func configureView() {
////        guard let navigationController = navigationController else { return }
////        navigationController.setNavigationBarHidden(false, animated: true)
////        navigationController.navigationBar.tintColor = .white
//////        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
////        navigationController.navigationBar.shadowImage = UIImage()
////        navigationController.navigationBar.isTranslucent = true
////        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//    }
//
//    func addFavoriteButton() {
//        favoriteBtn.accessibilityIdentifier = "favoriteBtnItem"
//        favoriteBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
//        favoriteBtn.setImage(UIImage(named: "heartIcon"), for: .normal)
//        favoriteBtn.setImage(UIImage(named: "heartIconFill"), for: .selected)
//        favoriteBtn.addTarget(self,
//                              action: #selector(favoriteButtonTapped(_:)),
//                              for: .touchUpInside)
//        let favoriteBtnItem = UIBarButtonItem(customView: favoriteBtn)
//        let currWidth = favoriteBtnItem.customView?.widthAnchor.constraint(equalToConstant: 24)
//        currWidth?.isActive = true
//        let currHeight = favoriteBtnItem.customView?.heightAnchor.constraint(equalToConstant: 24)
//        currHeight?.isActive = true
//        navigationItem.rightBarButtonItem = favoriteBtnItem
//    }
//
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            radioImageView.heightAnchor.constraint(equalToConstant: 200),
//            radioImageView.widthAnchor.constraint(equalToConstant: 200),
//
//            radioLabel.heightAnchor.constraint(equalToConstant: 80),
//            radioLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 24),
//            radioLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -24),
//
//            playButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 60),
//            playButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -60),
//            playButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//}
