//
//  FilterView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 31/08/24.
//

import SwiftUI
import SwiftyJSON


struct FilterView: View {
    
    @State var releaseYearsList: [JSON]
    @State var genresList: [JSON]
    @State var typesList: [JSON]
    
    var body: some View {
        List {
            
            Section("Жанр") {
                ForEach(0..<genresList.count) { index in
                    Text(genresList[index]["title"].stringValue)
                }
            }
            
            Section("Год выпуска") {
                ForEach(0..<releaseYearsList.count) { index in
                    Text(releaseYearsList[index]["title"].stringValue)
                }
            }
            
            Section("Тип") {
                ForEach(0..<typesList.count) { index in
                    Text(typesList[index]["title"].stringValue)
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Фильтр")
        
    }
}

#Preview {
    FilterView(releaseYearsList: [], genresList: [], typesList: [])
}
