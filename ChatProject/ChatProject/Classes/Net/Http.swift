//
//  Http.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/3/4.
//

import UIKit
import Alamofire
class Http: NSObject {
    static let manager: Http = Http()
    private override init() {
        
    }
    func get(url: String,params: [String: Any],progress:(currentBytes: Int, totalBytes: Int),response:(status: Int,result: Any,message: String)){
        Alamofire.request("", method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).downloadProgress { (progress) in
            print(progress)
        }.responseJSON { (response) in
            print(response)
        }
    }
    func post(url: String,params: [String: Any],progress:(currentBytes: Int, totalBytes: Int),response:(status: Int,result: Any,message: String)){
        
    }
}
