//
//  Parser+Genres.swift
//  OtakuSUI
//
//  Created by itserviceimac on 31/08/24.
//

import Foundation
import SwiftyJSON
import Kanna


extension Parser {
    
    func getGenres(from htmlString: String) -> [JSON] {
        var json = [JSON]()
        if let doc = try? HTML(html: htmlString, encoding: .windowsCP1251),
           let genres = doc.at_css(".anime_choose_block_ganres")?.innerHTML,
           let genresDoc = try? HTML(html: genres, encoding: .utf8) {
            for genreElement in genresDoc.css(".anime_choose_ganre") {
                if let link = genreElement.at_css("a")?["href"],
                   let title = genreElement.at_css("a")?.text {
                    json.append(JSON(parseJSON: """
                        {
                            "title": "\(title)",
                            "link": "\(link.replacingOccurrences(of: "/anime/", with: "").replacingOccurrences(of: "/", with: ""))"
                        }
                    """))
                }
            }
        }
        return json
    }
}
