//
//  RequestSender.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//

import Foundation
import Alamofire
import SwiftyJSON

public class RequestSender {
    
    static let serverURL: String = "https://jut.su/anime/"
    
    private let path: String
    private let parameters: Parameters?
    private let method: HTTPMethod
    private let completion: (JSON) -> Void
    private var timeout = 60
    
    init(path: String, parameters: Parameters? = nil, method: HTTPMethod = .get, completion: @escaping (JSON) -> Void) {
        self.path = path
        self.parameters = parameters
        self.method = method
        self.completion = completion
    }
    
    func exec() {
        print("🟡 Requesting: \(path)")
        
        guard let url = URL(string: "\(RequestSender.serverURL)\(path)") else {
            let customRes = JSON(["code": "-3", "message": "Invalid URL"])
            self.completion(customRes)
            return
        }
        
        let request = AF.request(url, method: method, parameters: parameters)
        
        request.responseData { response in
            var json: JSON
            
            switch response.result {
            case .success(let data):
                if let stringData = String(data: data, encoding: .windowsCP1251) {
                    json = JSON(["code": "200", "message": "success", "data": stringData])
                } else {
                    json = JSON(["code": "-5", "message": "Response Error"])
                }
                
            case .failure(let error):
                json = JSON(["code": "\(response.response?.statusCode ?? -5)",
                             "message": error.localizedDescription
                                            .replacingOccurrences(of: "\n", with: "|")
                                            .replacingOccurrences(of: "\"", with: "'")])
            }
            
            if response.response?.statusCode == 401 {
                json = JSON(["code": "401", "message": "Unauthorized"])
            }
            
            print("🟢 Completed: \(self.path)")
            self.completion(json)
        }
    }
}

