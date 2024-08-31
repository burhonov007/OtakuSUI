//
//  Parser+Info.swift
//  OtakuSUI
//
//  Created by itserviceimac on 30/08/24.
//

import Foundation
import Kanna
import SwiftyJSON


extension Parser {
    
    func getInfo(from str: String) -> JSON {
        var json = JSON()
        if let doc = try? HTML(html: str, encoding: .windowsCP1251) {
            json = JSON(parseJSON: """
            {
                "title": "\(extractOriginalTitle(from: doc))",
                "releaseYears": "\(extractYearOfIssue(from: doc))",
                "genres": "\(extractGenre(from: doc))",
                "rating": "\(extractRating(from: doc))",
                "ageLimit": "\(extractAgeRating(from: doc))",
                "desc": "\(extractDesc(doc: doc))"
            }
            """)
        }
        return json
    }
    
    private func extractDesc(doc: HTMLDocument) -> String {
        if let pElement = doc.at_css("p.under_video.uv_rounded_bottom.the_hildi") {
            if let spanElement = pElement.at_css("span") {
                var spanText = spanElement.text ?? ""
                
                spanText = spanText.replacingOccurrences(of: "<b>", with: "")
                spanText = spanText.replacingOccurrences(of: "</b>", with: "")
                
                let regexPattern = "<i>[^<]*</i>"
                if let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive) {
                    spanText = regex.stringByReplacingMatches(in: spanText, options: [], range: NSRange(location: 0, length: spanText.count), withTemplate: "")
                }
                
                spanText = spanText.trimmingCharacters(in: .whitespacesAndNewlines)
                
                return spanText
            }
        }
        return ""
    }
    
    
    private func extractAgeRating(from doc: HTMLDocument) -> String {
        if let aniAgeRating = doc.at_css("span.age_rating_all") {
            return aniAgeRating.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        return ""
    }


    private func extractRating(from doc: HTMLDocument) -> String {
        if let ratingValue = doc.at_xpath("//span[@class='rating_meta']/span/span[2]") {
            return ratingValue.text ?? ""
        }
        return ""
    }


    private func extractOriginalTitle(from doc: HTMLDocument) -> String {
        if let ratingValue = doc.at_xpath("//span[@class='rating_meta']/span/span[1]") {
            if let text = ratingValue.innerHTML?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if let startIndex = text.range(of: "alternateName\" content=\"")?.upperBound,
                   let endIndex = text[startIndex...].range(of: "\"")?.lowerBound {
                    let extractedText = text[startIndex..<endIndex]
                    return String(extractedText)
                }
            }
        }
        return ""
    }



    private func extractYearOfIssue(from doc: HTMLDocument) -> String {
        if let desc = doc.at_css("div.under_video_additional")?.content {
            let searchString = "Год выпуска: Аниме"
            if desc.contains(searchString) {
                if let startIndex = desc.range(of: searchString)?.upperBound,
                   let endIndex = desc[startIndex...].range(of: ".")?.lowerBound {
                    let extractedText = desc[startIndex..<endIndex].replacingOccurrences(of: " ", with: "")
                    return extractedText
                }
            } else {
                if let startIndex = desc.range(of: "Годы выпуска: Аниме")?.upperBound,
                   let endIndex = desc[startIndex...].range(of: ".")?.lowerBound {
                    let extractedText = desc[startIndex..<endIndex].replacingOccurrences(of: " Аниме ", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                    return extractedText
                }
            }
        }
        return ""
    }


    private func extractGenre(from doc: HTMLDocument) -> String {
        if let desc = doc.at_css("div.under_video_additional")?.content,
           let range = desc.range(of: ".") {
            let textBeforeDot = desc[..<range.lowerBound]
            var formattedText = textBeforeDot.replacingOccurrences(of: "Аниме", with: "").trimmingCharacters(in: .whitespaces)
            formattedText = formattedText.replacingOccurrences(of: "  ", with: " ")
            return formattedText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }
    
}
