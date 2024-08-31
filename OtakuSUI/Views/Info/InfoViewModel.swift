//
//  InfoViewModel.swift
//  OtakuSUI
//
//  Created by itserviceimac on 30/08/24.
//

import Foundation
import SwiftyJSON


class InfoViewModel: ObservableObject {
    
    @Published var info: JSON = JSON()
    @Published var isCatchError: Bool = false
    @Published var notLoadedPage: Int = 0
    @Published var htmlString: String = ""
    
    func fetchInfo(from urlString: String, completion: (()->())? = nil) {
        RequestSender(path: urlString) { json in
            if json["code"].stringValue == "200" && json["message"].stringValue == "success" {
                let info = Parser.shared.getInfo(from: json["data"].stringValue)
                self.htmlString = json["data"].stringValue
                self.info = info
                completion?()
            } else {
                self.isCatchError = true
            }
        }.exec()
    }
    
}
