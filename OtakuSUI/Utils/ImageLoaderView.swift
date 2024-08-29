//
//  ImageLoaderView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct ImageLoaderView: View {
    
    var urlString: String = "https://dummyjson.com/image/150"
    let resizingMode: ContentMode = .fit
    
    var body: some View {
        
        WebImage(url: URL(string: urlString)) { image in
            image
        } placeholder: {
            Image(systemName: "photo.artframe")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
        }
        .resizable()
        .indicator(.activity)
        .aspectRatio(contentMode: resizingMode)
        .allowsHitTesting(false)
        
    }
}

#Preview {
    ImageLoaderView()
        .padding(40)
        .padding(.vertical, 60)
    
}
