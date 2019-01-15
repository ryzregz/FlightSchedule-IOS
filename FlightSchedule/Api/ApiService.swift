//
//  ApiService.swift
//  FlightSchedule
//
//  Created by Morris on 14/01/2019.
//  Copyright © 2019 Morris. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class ApiService {
    static func generateTokenRequest( onSuccess:@escaping (_ responseData: JSON)->Void, onError: @escaping (_ errorMessage: String?)->Void){
        let headers: HTTPHeaders = [ "Content-Type" : "application/x-www-form-urlencoded"]
        let url = Config.sharedManager.token_url
        let parameters: Parameters=[
            "client_id": "pd6gszjd624r3ze98nad3kb4",
            "client_secret":"HKKbvT4nrT",
            "grant_type":"client_credentials"
        ]
        
        Alamofire.request(url, method: HTTPMethod.post, parameters : parameters,  encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            print("API RESPONSE \(response)")
            if  response.result.error != nil {
                onError(response.result.error as? String)
                return
            }
            let json : JSON = JSON(response.data!)
           
            onSuccess(json)
           
        }
        
}
    
    
    static func getRequest(method:String, onSuccess:@escaping (_ responseData: JSON)->Void, onError: @escaping (_ errorMessage: String?)->Void){
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Config.sharedManager.auth_token)", "Accept":"application/json"]
        let url = Config.sharedManager.request_url+method
        
        Alamofire.request(url, method: HTTPMethod.get, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            print("API RESPONSE \(response)")
            if  response.result.error != nil {
                onError(response.result.error as? String)
                return
            }
            let json : JSON = JSON(response.data!)
            
            onSuccess(json)
            
        }
        
    }
}
