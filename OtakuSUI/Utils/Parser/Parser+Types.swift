//
//  Parser+Types.swift
//  OtakuSUI
//
//  Created by itserviceimac on 31/08/24.
//

import Foundation
import SwiftyJSON
import Kanna

extension Parser {
    
    func getTypes(from htmlString: String) -> [JSON] {
        var json = [JSON]()
        if let doc = try? HTML(html: htmlString, encoding: .windowsCP1251),
           let types = doc.at_css(".anime_types_are_here")?.innerHTML,
           let typesDoc = try? HTML(html: types, encoding: .utf8) {
            for genreElement in typesDoc.css(".anime_choose_ganre") {
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
        print(json)
        return json
    }
    
}
