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
            
            if sections.count > 0 {
                for section in sections {
                    if let titleLink = section.at_css("a")?["href"],
                       let fullTitle = section.text {
                        var seriesJARR = [JSON]()
                        extrackLinks(doc: doc, title: fullTitle, titleLink: titleLink, seriesJARR: &seriesJARR)
                        seasonsJOB["title"].stringValue = fullTitle
                        seasonsJOB["series"].arrayObject = seriesJARR
                        seriesList.append(seasonsJOB)
                    }
                }
            } else {
                var seriesJARR = [JSON]()
                seasonsJOB["title"].stringValue = animeName
                for link in doc.xpath("//a") {
                    if let href = link["href"], let text = link.text {
                        if !href.hasPrefix("https://") && (href.contains("/episode-")) {
                            let title = text.replacingOccurrences(of: animeName+" ", with: "")
                            seriesJARR.append(JSON(parseJSON: """
                                {
                                    "href": "\(href)",
                                    "title": "\(title)"
                                }
                                """
                                )
                            )
                        }
                    }
                }
                seasonsJOB["series"].arrayObject = seriesJARR
                seriesList.append(seasonsJOB)
            }
            extracktMovies(doc: doc, animeName: animeName, seriesList: &seriesList)
        }
        
        return seriesList
        
    }
    
    
    private func extrackLinks(doc: HTMLDocument, title: String, titleLink: String, seriesJARR: inout [JSON]) {
        for link in doc.xpath("//a") {
            if let href = link["href"], let text = link.text {
                if !href.hasPrefix("https://") && href.contains(titleLink) {
                    if text != title {
                        
                        let fullTitle = title
                        let titleBeforeParenthesis = fullTitle.components(separatedBy: " (").first ?? ""
                        
                        let seriesHint = text.replacingOccurrences(of: titleBeforeParenthesis+" ", with: "")
                        seriesJARR.append(JSON(parseJSON: """
                            {
                                "href": "\(href)",
                                "title": "\(seriesHint)"
                            }
                            """
                            )
                        )
                    }
                }
            }
        }
    }
    
    
    private func extracktMovies(doc: HTMLDocument, animeName: String, seriesList: inout [JSON]) {
        if let titleNode = doc.xpath("//h2[contains(@class, 'b-b-title') and contains(@class, 'the-anime-season') and contains(@class, 'center') and contains(@class, 'films_title')]").first {
            
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
    
}

