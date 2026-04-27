import SwiftUI

struct LaunchModule {
    let healthService: HealthServicing
    let shouldAnimate: Bool
    let onFinished: () -> Void
    
    @MainActor
    func makeView() -> some View {
        let viewModel = LaunchViewModel(healthService: healthService)
        return LaunchView(
            viewModel: viewModel,
            shouldAnimate: shouldAnimate,
            onFinished: onFinished
        )
    }
}
