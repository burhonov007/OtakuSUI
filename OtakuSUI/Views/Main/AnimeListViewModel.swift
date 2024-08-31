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
    
    @Published var sortList: [JSON] = [JSON]()
    @Published var genreList: [JSON] = [JSON]()
    @Published var releaseYearsList: [JSON] = [JSON]()
    @Published var typeList: [JSON] = [JSON]()
    
    @Published var currentPage: Int = 1
    @Published var isCatchError: Bool = false
    @Published var notLoadedPage: Int = 0
    
    @Published var selectedGenres: Set<String> = []
    @Published var selectedReleaseYears: Set<String> = []
    @Published var selectedSort = ""
    
    func fetchAnime(from urlString: String, completion: (()->())? = nil) {
        RequestSender(path: urlString) { json in
            if json["code"].stringValue == "200" && json["message"].stringValue == "success" {
                let animes = Parser.shared.get(from: json["data"].stringValue)
                self.animeList += animes
                if self.sortList.isEmpty { self.sortList = Parser.shared.getSort(from: json["data"].stringValue) }
                if self.genreList.isEmpty { self.genreList = Parser.shared.getGenres(from: json["data"].stringValue) }
                if self.releaseYearsList.isEmpty { self.releaseYearsList = Parser.shared.getReleaseYears(from: json["data"].stringValue) }
                if self.typeList.isEmpty { self.typeList = Parser.shared.getTypes(from: json["data"].stringValue) }            
                completion?()
            } else {
                self.notLoadedPage = self.currentPage - 1
                self.isCatchError = true
            }
        }.exec()
    }
    
}
