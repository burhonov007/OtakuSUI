//
//  Parser+Series.swift
//  OtakuSUI
//
//  Created by itserviceimac on 30/08/24.
//

import Foundation
import Kanna
import SwiftyJSON


extension Parser {
    
    func fetchSeries(from str: String, animeName: String) -> [JSON] {
        var seriesList = [JSON]()
        
        if let doc = try? HTML(html: str, encoding: .windowsCP1251) {
            let sections = doc.css("div.the_invis")
            
            var seasonsJOB: JSON = JSON()
            
            for section in sections {
                if let titleLink = section.at_css("a")?["href"],
                   let title = section.text {
                    seasonsJOB["title"].stringValue = title
                    
                    var seriesJARR = [JSON]()
                    for link in doc.xpath("//a") {
                        if let href = link["href"], let text = link.text {
                            if !href.hasPrefix("https://") && href.contains(titleLink) {
                                if text != title {
                                    let seriesHint = text.replacingOccurrences(of: title+" ", with: "")
                                    seriesJARR.append(JSON(parseJSON: """
                                        {
                                            "href": "\(href)",
                                            "title": "\(seriesHint)"
                                        }
                                        """)
                                    )
                                }
                            }
                        }
                    }
                    seasonsJOB["series"].arrayObject = seriesJARR
                    seriesList.append(seasonsJOB)
                }
            }
            
            if let titleNode = doc.xpath("//h2[contains(@class, 'b-b-title') and contains(@class, 'the-anime-season') and contains(@class, 'center') and contains(@class, 'films_title') and text()='Полнометражные фильмы']").first {
                
                var moviesJOB = JSON()
                var moviesJARR = [JSON]()
                
                let titleText = titleNode.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Заголовок"
                moviesJOB["title"].stringValue = titleText
                
                
                var nextSibling = titleNode.nextSibling
                while let node = nextSibling {
                    if node.tagName == "a", let href = node["href"], let linkText = node.text {
                        moviesJARR.append(JSON(parseJSON: """
                            {
                                "href": "\(href)",
                                "title": "\(linkText.replacingOccurrences(of: animeName+" ", with: "").trimmingCharacters(in: .whitespacesAndNewlines))"
                            }
                            """)
                        )
                    }
                    nextSibling = node.nextSibling
                }
                
                moviesJOB["series"].arrayObject = moviesJARR
                seriesList.append(moviesJOB)
                
                
            }
            
        }
        print(seriesList)
        return seriesList
        
    }
    
}

