import SwiftUI

/// Splash screen that optionally animates the logo and then calls `onFinished`.
struct LaunchView: View {
    let shouldAnimate: Bool
    let isLoading: Bool
    let onAppearAction: () -> Void
    let onFinished: () -> Void

    @State private var isAnimating = false
    @State private var isSpinning = false

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
                    .opacity(isSpinning ? 1.0 : 0.0)
                    .offset(y: 72)
            }
            .task {
                onAppearAction()
                await run()
            }
    }
    
    private func Spinner() -> some View {
        SpinnerView(name: "loader1010-white-11px")
            .frame(width: 44, height: 44)
        
    }

    private func run() async {
        if shouldAnimate {
            await MainActor.run {
                withAnimation(.smooth(duration: 2).speed(0.6)) {
                    isAnimating = true
                }
            }

            // Keep the splash visible a little longer than the animation.
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            isSpinning = true
        }

        await MainActor.run {
            onFinished()
        }
    }
}

#if DEBUG
#Preview {
    LaunchView(
        shouldAnimate: true,
        isLoading: true,
        onAppearAction: {},
        onFinished: {}
    )
}
#endif
