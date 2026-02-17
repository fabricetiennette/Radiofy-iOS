//import UIKit
//import SwiftUI

//protocol LaunchOutputBinding: ObservableObject {
//    var isOn: Bool { get }
//    
//    func start() async
//}
//
//protocol LaunchServiceProtocol {
//    var isUserLoggedIn: Bool { get }
//    
//    func setFirebaseEmailLanguage()
//}
//
//protocol LaunchViewModelDelegate: AnyObject {
//    func showOnboardingPath()
//    func showHomeTabBar()
//}
//
//final class LaunchModule {
//    
//    private let needAnimation: Bool
//        private let service: LaunchServiceProtocol
//
//        init(service: LaunchServiceProtocol, needAnimation: Bool) {
//            self.service = service
//            self.needAnimation = needAnimation
//        }
//
//        func makeView(
//            onHome: @escaping () -> Void,
//            onOnboarding: @escaping () -> Void
//        ) -> some View {
//            let viewModel = LaunchViewModel(
//                service: service,
//                needAnimation: needAnimation,
//                onHome: onHome,
//                onOnboarding: onOnboarding
//            )
//            return LaunchView(viewModel: viewModel)
//        }
    
//
//    typealias ViewModel = LaunchOutputBinding
//    typealias Service = LaunchServiceProtocol
//    typealias CoordinatorDelegate = LaunchViewModelDelegate

//    private weak var coordinatorDelegate: CoordinatorDelegate?
//    private let needAnimation: Bool
//
//    var launchView: some View {
//        let service = LaunchService()
//        let viewModel = LaunchViewModel(service: service, needAnimation: needAnimation)
//        viewModel.delegate = coordinatorDelegate
//        return LaunchView(viewModel: viewModel)
//    }
//
//    init(coordinatorDelegate: CoordinatorDelegate?, needAnimation: Bool) {
//        self.coordinatorDelegate = coordinatorDelegate
//        self.needAnimation = needAnimation
//    }
//}
