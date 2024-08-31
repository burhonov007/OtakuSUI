//
//  Parser.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//

import Foundation
import SwiftyJSON
import Kanna

class Parser {
    
    static let shared = Parser()
    
    func get(from str: String) -> [JSON] {
        var animeList = [JSON]()
        
        if let doc = try? HTML(html: str, encoding: .windowsCP1251) {
            for animeListElement in doc.css(".all_anime_global") {
                if let animeName = animeListElement.at_css(".aaname")?.text,
                   var animeLink = animeListElement.at_css("a")?["href"],
                   var animeSeries = animeListElement.at_css(".aailines")?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let imageUrl = animeListElement.at_css(".all_anime_image")?["style"]?.components(separatedBy: "'")[1] {
                    
                    // MARK: - Edit Variables
                    animeLink = animeLink.replacingOccurrences(of: "/", with: "")
                    animeSeries = animeSeries.replacingOccurrences(of: "сезона", with: "сезона ")
                    animeSeries = animeSeries.replacingOccurrences(of: "сезонов", with: "сезонов ")
                    animeSeries = animeSeries.replacingOccurrences(of: "серий", with: "серий ")
                    animeSeries = animeSeries.replacingOccurrences(of: "серии", with: "серии ")
                    animeSeries = animeSeries.replacingOccurrences(of: "серия", with: "серия ")
                    
                    // MARK: - Create JSON Object
                    let animeJSON: JSON = [
                        "name": animeName,
                        "link": animeLink,
                        "series": animeSeries,
                        "imageUrl": imageUrl
                    ]
                    
                    animeList.append(animeJSON)
                }
            }
        }
        return animeList
    }
}
