//
//  SearchModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 26/09/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

//import UIKit
//import Combine
//
//struct SearchModule {
//
//    typealias ViewModel = SearchOutputBinding & SearchInputBinding
//    typealias CoordinatorDelegate = SearchViewModelDelegate
//
//    private weak var coordinatorDelegate: CoordinatorDelegate?
//
//    init(coordinatorDelegate: CoordinatorDelegate?) {
//        self.coordinatorDelegate = coordinatorDelegate
//    }
//
//    var viewController: UIViewController {
//        let viewModel = SearchViewModel()
//        let searchViewController = SearchViewController(viewModel: viewModel)
//        viewModel.delegate = coordinatorDelegate
//        return searchViewController
//    }
//}
//
//protocol SearchInputBinding {
//    func getAllRadioStations()
//}
//
//protocol SearchOutputBinding {
//    var updateAllStationsSubject: PassthroughSubject<[RadioStation], Never> { get set }
//    func showSelectedRadioPage(with radio: RadioStation)
//}
//
//protocol SearchViewModelDelegate: AnyObject {
//    func selectRadio(_ radio: RadioStation)
//}

//
//  SearchModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 26/09/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import SwiftUI

/// Builds the Search feature (SwiftUI) with its dependencies.
/// Keeps composition outside the view for a clean architecture.
struct SearchModule {
    let radioService: RadioServicing
    let stationRepository: StationRepositing
    /// Lets the host hide its header while the search field is active.
    let isSearchActive: Binding<Bool>

    @MainActor
    func makeView() -> some View {
        let viewModel = SearchViewModel(
            radioService: radioService,
            stationRepository: stationRepository
        )
        return SearchView(viewModel: viewModel, isSearchActive: isSearchActive)
    }
}
