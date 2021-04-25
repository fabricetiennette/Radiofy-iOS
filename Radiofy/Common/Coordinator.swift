import Foundation
import UIKit

protocol CoordinatorType: AnyObject {
    func start()
}

class Coordinator<RootView>: CoordinatorType {

    private var childrens: [CoordinatorType]
    let rootView: RootView

    init(rootView: RootView) {
        childrens = []
        self.rootView = rootView
    }

    func add(children: CoordinatorType) {
        childrens.append(children)
    }

    func start() {}
}

protocol CoordinatorDelegate: class {
    func finish(from coordinator: CoordinatorType)
}

extension Coordinator: CoordinatorDelegate {
    func finish(from coordinator: CoordinatorType) {
        for (index, children) in childrens.enumerated() where coordinator === children {
            childrens.remove(at: index)
            break
        }
    }
}
