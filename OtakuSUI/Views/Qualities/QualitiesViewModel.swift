//
//  QualitiesViewModel.swift
//  OtakuSUI
//
//  Created by itserviceimac on 01/09/24.
//

import Foundation
import SwiftyJSON


class QualitiesViewModel: ObservableObject {
    
    @Published var qualitiesList: [JSON] = [JSON]()
    @Published var isCatchError: Bool = false
    
    func fetchQualities(from urlString: String, completion: (()->())? = nil) {
        RequestSender(path: urlString) { json in
            if json["code"].stringValue == "200" && json["message"].stringValue == "success" {
                self.qualitiesList = Parser.shared.getQualities(from: json["data"].stringValue)
                completion?()
            } else {
                self.isCatchError = true
            }
        }.exec()
    }
    
}
