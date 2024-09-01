//
//  QualitiesView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 01/09/24.
//

import SwiftUI
import SwiftyJSON


struct QualitiesView: View {
    
    @ObservedObject var vm = QualitiesViewModel()
    
    @State var episodeLink: String
    
    var body: some View {
        List {
            Section("Качество") {
                ForEach(0..<vm.qualitiesList.count, id: \.self) { index in
                    NavigationLink {
                        let qualityUrl = vm.qualitiesList[index]["url"].stringValue
                        VideoPlayerView(videoURLString: qualityUrl)
                    } label: {
                        Text(vm.qualitiesList[index]["title"].stringValue)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.fetchQualities(from: episodeLink)
        }
    }
}

#Preview {
    QualitiesView(episodeLink: "")
}
