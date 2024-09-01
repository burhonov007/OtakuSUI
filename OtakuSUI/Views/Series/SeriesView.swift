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
    
    var body: some View {
        List {
            ForEach(0..<vm.series.count, id: \.self) { index in
                let season = vm.series[index]
                Section(header: Text(season["title"].stringValue)) {
                    let episodes = season["series"].arrayValue
                    
                    ForEach(0..<episodes.count, id: \.self) { episodeIndex in
                        NavigationLink {
                            QualitiesView(episodeLink: episodes[episodeIndex]["href"].stringValue)
                        } label: {
                            Text(episodes[episodeIndex]["title"].stringValue)
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




