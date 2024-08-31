//
//  Parser+Sort.swift
//  OtakuSUI
//
//  Created by itserviceimac on 31/08/24.
//

import Foundation
import SwiftyJSON
import Kanna


extension Parser {
    
    func getSort(from htmlString: String) -> [JSON] {
        var json = [JSON]()
        if let doc = try? HTML(html: htmlString, encoding: .windowsCP1251), let _ = doc.at_css(".anime_choose_block_order")!.innerHTML {
            for orderElement in doc.css(".anime_choose_order") {
                if let link = orderElement.at_css("a")?["href"] {
                    let title = orderElement.at_css("a")?.text ?? ""
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
