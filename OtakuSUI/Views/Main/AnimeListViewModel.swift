//
//  AnimeListViewModel.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//

import Foundation
import SwiftyJSON


class AnimeListViewModel: ObservableObject {
    
    @Published var animeList: [JSON] = [JSON]()
    @Published var currentPage: Int = 1
    @Published var isCatchError: Bool = false
    @Published var notLoadedPage: Int = 0
    
    func fetchAnime(from urlString: String, completion: (()->())? = nil) {
        RequestSender(path: urlString) { json in
            if json["code"].stringValue == "200" && json["message"].stringValue == "success" {
                let animes = Parser.shared.get(from: json["data"].stringValue)
                self.animeList += animes
                completion?()
            } else {
                self.notLoadedPage = self.currentPage - 1
                self.isCatchError = true
            }
        }.exec()
    }
    
}
