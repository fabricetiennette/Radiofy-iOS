import SwiftUI

/// Splash screen that optionally animates the logo and then calls `onFinished`.
struct LaunchView: View {
    let shouldAnimate: Bool
    let onAppearAction: () -> Void
    let onFinished: () -> Void

    @State private var isAnimating = false

    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay {
                VStack {
                    Image(asset: Asset.radiofy)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : -60)
                }
            }
            .task {
                onAppearAction()
                await run()
            }
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
        onAppearAction: {},
        onFinished: {}
    )
}
#endif
