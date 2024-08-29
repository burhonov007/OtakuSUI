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
    
    func fetchAnime(from urlString: String, completion: (()->())? = nil) {
        RequestSender(path: urlString) { json in
            let animes = Parser.shared.get(from: json["data"].stringValue)
            self.animeList += animes
            completion?()
        }.exec()
    }
}
