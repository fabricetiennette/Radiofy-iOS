//
//  RadiofyViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 06/10/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

protocol RadiofyViewControllerProtocol: AnyObject {
    associatedtype ViewModelGenericType

    init(viewModel: ViewModelGenericType)
}

class RadiofyViewController<U>: UIViewController, RadiofyViewControllerProtocol {

    typealias ViewModelGenericType = U
    let viewModel: ViewModelGenericType

    convenience init() {
        fatalError("init() has not been implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(viewModel: ViewModelGenericType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
}
