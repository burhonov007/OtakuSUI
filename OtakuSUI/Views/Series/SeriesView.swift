//
//  SeriesView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 30/08/24.
//

import SwiftUI
import SwiftyJSON


struct SeriesView: View {
    
    @ObservedObject var vm = SeriesViewModel()
    
    @State var htmlString: String
    @State var animeName: String
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        List {
            ForEach(0..<vm.series.count, id: \.self) { index in
                let season = vm.series[index]
                Section(header: Text(season["title"].stringValue)) {
                    let episodes = season["series"].arrayValue
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(0..<episodes.count, id: \.self) { episodeIndex in
                            Text(episodes[episodeIndex]["title"].stringValue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.fetchSeries(from: htmlString, animeName: animeName)
        }
    }
}

#Preview {
    SeriesView(htmlString: "", animeName: "")
}




