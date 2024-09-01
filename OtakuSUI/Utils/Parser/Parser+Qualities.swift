//
//  Parser+Qualities.swift
//  OtakuSUI
//
//  Created by itserviceimac on 01/09/24.
//

import Foundation
import Kanna
import SwiftyJSON


extension Parser {
    
    func getQualities(from htmlString: String) -> [JSON] {
        
        var json = [JSON]()
        if let doc = try? HTML(html: htmlString, encoding: .windowsCP1251) {
            let sources = doc.xpath("//source")
            for source in sources {
                if let src = source["src"], let title = source["label"] {
                    json.append(JSON(parseJSON: """
                        {
                            "title": "Качество \(title)",
                            "url": "\(src)",
                        }
                    """))
                }
            }
        }
        return json
    }
    
}
