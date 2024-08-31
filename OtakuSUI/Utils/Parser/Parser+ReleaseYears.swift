//
//  Parser+ReleaseYears.swift
//  OtakuSUI
//
//  Created by itserviceimac on 31/08/24.
//

import Foundation
import SwiftyJSON
import Kanna


extension Parser {
    
    func getReleaseYears(from htmlString: String) -> [JSON] {
        var json = [JSON]()
        if let doc = try? HTML(html: htmlString, encoding: .windowsCP1251),
           let years = doc.at_css(".anime_years_are_here")?.innerHTML,
           let yearsDoc = try? HTML(html: years, encoding: .utf8) {
            for genreElement in yearsDoc.css(".anime_choose_year") {
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
