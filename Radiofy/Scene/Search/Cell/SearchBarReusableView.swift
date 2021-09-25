//
//  SearchBarReusableView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class SearchBarReusableView: UICollectionReusableView {

    @IBOutlet private weak var searchBar: UISearchBar!

    func configureSearchBar() {

        searchBar.placeholder = L1s.searchRadio
        searchBar.tintColor = UIColor(cgColor: #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1))
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
