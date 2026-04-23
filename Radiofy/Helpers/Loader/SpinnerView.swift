import SwiftUI
import Lottie

struct SpinnerView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore

        if let animation = LottieAnimation.named(name, bundle: .main) {
            animationView.animation = animation
            animationView.play()
        } else {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Lottie introuvable: \(name).json"
            label.textColor = .red
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            label.textAlignment = .center
            label.numberOfLines = 0

            container.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
                label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        }

        container.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: container.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct LoadingLottieTestView: View {
    var body: some View {
        ZStack {
            SpinnerView(name: "loader1010-white-11px")
                .frame(width: 80, height: 80)
        }
    }
}

#Preview("Spinner Lottie Test") {
    ZStack {
        Color.black
            .ignoresSafeArea()
        LoadingLottieTestView()
    }
}
