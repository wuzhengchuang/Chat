//
//  Http.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/3/4.
//

import UIKit
import Alamofire
class Http: NSObject {
    static let host: String = "https://youyanapi.dalianjucheng.cn"
    static let host_h5: String = "https://yyh5-1309677820.cos.ap-beijing.myqcloud.com"
    static let host_image: String = "https://static.dalianjucheng.cn"
    
    static let manager: Http = Http()
    private override init() {
        
    }
    func get(url: String,params: [String: Any]?,progress:(_ progress: Progress) -> (),response:(_ status: Int,_ result: Any,_ message: String) ->()){
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).downloadProgress { (downloadProgress) in
            print(downloadProgress)
            
        }.responseJSON { (response1) in
            print(response1)
            
        }
    }
    func post(url: String,params: [String: Any],progress:(currentBytes: Int, totalBytes: Int),response:(status: Int,result: Any,message: String)){
        
    }
}
extension Http {
    static var getUserInfo :String{
        return Self.host + "/user/getUserInfo"
    }
    static var getBannerUrl :String{
        return Self.host + "/config/getBannerUrl"
    }
}
