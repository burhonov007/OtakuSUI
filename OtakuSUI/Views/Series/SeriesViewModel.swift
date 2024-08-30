//
//  SeriesViewModel.swift
//  OtakuSUI
//
//  Created by itserviceimac on 30/08/24.
//

import Foundation
import SwiftyJSON


class SeriesViewModel: ObservableObject {
    
    @Published var series: [JSON] = [JSON]()
    @Published var isCatchError: Bool = false
    
    func fetchSeries(from htmlString: String, animeName: String) {
        series = Parser.shared.fetchSeries(from: htmlString, animeName: animeName)
    }
    
}
