//
//  AnimeListRow.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//

import SwiftUI

struct AnimeListRow: View {
    
    var imageURL: String
    var name: String
    var seriesCount: String
    
    var body: some View {
        HStack {
            
            ImageLoaderView(urlString: imageURL)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
            Spacer().frame(width: 15)
            
            VStack(alignment: .leading, spacing: 15) {
                
                Text(name)
                    .font(.title2)
                
                Text(seriesCount)
                    .font(.subheadline)
                    .lineLimit(2)
                
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    AnimeListRow(imageURL: "1", name: "1", seriesCount: "2")
        .padding(.horizontal, 15)
        .frame(height: 100)
}
