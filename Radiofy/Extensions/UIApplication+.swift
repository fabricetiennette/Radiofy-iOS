//
//  UIApplication+.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 18/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
