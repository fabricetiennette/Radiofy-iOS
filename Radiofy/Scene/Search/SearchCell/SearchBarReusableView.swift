//
//  SearchBarReusableView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Reusable

final class SearchBarReusableView: UICollectionReusableView, NibReusable {

    @IBOutlet weak var searchBar: UISearchBar!

    func configureSearchBar() {
        searchBar.placeholder = L10n.searchYourRadio
        searchBar.tintColor = Asset.greenMain.color
        searchBar.searchTextField.accessibilityIdentifier = "RadioSearchTextField"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.leftView?.tintColor = .black
    }
}

extension UISearchBar {
    var text4Field: UITextField? {
        return subviews.first?.subviews.first(where: { $0.isKind(of: UITextField.self) }) as? UITextField
    }
}
