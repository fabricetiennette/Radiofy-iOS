//
//  LaunchView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 16.04.2024.
//  Copyright © 2024 Fabrice Etiennette. All rights reserved.
//

import SwiftUI

struct LaunchView<ViewModel>: View where ViewModel: LaunchModule.ViewModel {
    @ObservedObject var viewModel: ViewModel
    
    @State private var isAnimating = false
    
    var body: some View {
        Color.black
            .edgesIgnoringSafeArea(.all)
            .overlay {
                VStack {
                    Image(asset: Asset.radiofy)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : -60)
                }
            }
            .onAppear(perform: {
                viewModel.setupEmailLanguage()
                startAnimation()
            })
    }
    
    private func startAnimation() {
        switch viewModel.isOn {
        case true:
            animateLogo()
            
        case false:
            viewModel.isUserLoggedIn()
        }
    }
    
    private func animateLogo() {
        withAnimation(.smooth(duration: 2).speed(0.6)) {
            isAnimating = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            viewModel.isUserLoggedIn()
        }
    }
}

#if DEBUG
#Preview {
    let service = LaunchService()
    let viewModel = LaunchViewModel(service: service, needAnimation: true)
    return Group {
        LaunchView(viewModel: viewModel)
    }
}
#endif
