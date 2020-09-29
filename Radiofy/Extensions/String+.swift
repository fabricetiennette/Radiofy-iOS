//
//  String+.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

extension String {

    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: self)
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func isNameValid() -> Bool {
        let name = self
        if name.count == 1 || name.count > 15 {
            return false
        }
        return true
    }
}

extension Optional where Wrapped == String {

    func clearedText() -> String {
        guard let text = self?.trimmingCharacters(in: .whitespacesAndNewlines) else { return "" }
        return text
    }
}

extension Array {
    func pick(_ index: Int) -> [Element] {
        guard count >= index else {
            print(index)
            fatalError("The count has to be at least \(index)")
        }
        guard index >= 0 else {
            fatalError("The number of elements to be picked must be positive")
        }

        let shuffledIndices = indices.shuffled().prefix(upTo: index)
        return shuffledIndices.map {self[$0]}
    }
}
