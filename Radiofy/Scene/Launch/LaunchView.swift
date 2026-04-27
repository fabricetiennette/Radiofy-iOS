import SwiftUI

struct LaunchView: View {
    
    @StateObject var viewModel: LaunchViewModel
    
    let shouldAnimate: Bool
    let onFinished: () -> Void

    @State private var isAnimating = false
    @State private var minimumAnimationCompleted = false
    @State private var shouldShowSpinner = false
    @State private var loadingMessage: String?
    private let errorMessage = "Unknown error"

    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay {
                Image(asset: Asset.radiofy)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : -60)
            }
            .overlay {
                Spinner()
                    .opacity(shouldShowSpinner && viewModel.isLoading ? 1.0 : 0.0)
                    .offset(y: 72)
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 8) {
                    Text(loadingMessage ?? "")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                        .opacity(loadingMessage != nil && !viewModel.hasError ? 1.0 : 0.0)

                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .opacity(viewModel.hasError ? 1.0 : 0.0)
                }
                .padding(.bottom, 24)
            }
            .task {
                await run()
            }
            .onChange(of: viewModel.isLoading) { _, isLoading in
                guard minimumAnimationCompleted, !isLoading else { return }
                onFinished()
            }
    }
    
    private func Spinner() -> some View {
        SpinnerView(name: "loader1010-white-11px")
            .frame(width: 44, height: 44)
    }

    private func run() async {
        async let healthTask: Void = viewModel.pingRequest()

        if shouldAnimate {
            await MainActor.run {
                withAnimation(.smooth(duration: 2).speed(0.6)) {
                    isAnimating = true
                }
            }

            try? await Task.sleep(nanoseconds: 2_500_000_000)
        } else {
            await MainActor.run {
                isAnimating = true
            }
        }

        await MainActor.run {
            minimumAnimationCompleted = true
            shouldShowSpinner = true
        }

        let loadingMessageTask = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if viewModel.isLoading && !viewModel.hasError {
                    loadingMessage = "Please wait"
                }
            }

            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if viewModel.isLoading && !viewModel.hasError {
                    loadingMessage = "Getting things ready"
                }
            }

            try? await Task.sleep(nanoseconds: 4_000_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if viewModel.isLoading && !viewModel.hasError {
                    loadingMessage = "Loading"
                }
            }

            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if viewModel.isLoading && !viewModel.hasError {
                    loadingMessage = "Almost there"
                }
            }
        }

        await healthTask
        loadingMessageTask.cancel()

        await MainActor.run {
            loadingMessage = nil
        }

        if !viewModel.isLoading {
            await MainActor.run {
                onFinished()
            }
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = LaunchViewModel(healthService: HealthService(baseURL: AppConfig.apiBaseURL))
    
    NavigationStack {
        LaunchView(
            viewModel: viewModel,
            shouldAnimate: true,
            onFinished: {}
        )
    }
}
#endif
