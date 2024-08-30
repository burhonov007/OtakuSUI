//
//  SeriesView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 30/08/24.
//

import SwiftUI

struct SeriesView: View {
    
    
    @ObservedObject var vm = SeriesViewModel()
    
    @State var htmlString: String
    @State var animeName: String
    
    let items = Array(1...20)
        
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        Text("Серия \(item)")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .onAppear {
                vm.fetchSeries(from: htmlString, animeName: animeName)
            }
        }
}

#Preview {
    SeriesView(htmlString: "", animeName: "")
}
