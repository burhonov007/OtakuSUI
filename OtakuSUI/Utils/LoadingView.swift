//
//  LoadingView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//

import Foundation
import SwiftUI

struct LoadingView<Content: View>: View {
    @Binding var isLoading: Bool
    let content: Content
    
    init(isLoading: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 5 : 0)
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                }
                .frame(width: 80, height: 80)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .transition(.opacity)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    LoadingView(isLoading: .constant(true)) {
        VStack {
            Text("eqwqeqwe")
        }
    }
}
