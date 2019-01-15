//
//  Config.swift
//  FlightSchedule
//
//  Created by Morris on 14/01/2019.
//  Copyright © 2019 Morris. All rights reserved.
//

import Foundation
import SwiftyJSON
class Config{
    var token_url = "https://api.lufthansa.com/v1/oauth/token"
    var request_url = "https://api.lufthansa.com/v1/"
    var auth_token = ""
    var Airports: JSON?
    class var sharedManager: Config {
        struct Static {
            static let instance = Config()
        }
        return Static.instance
    }
    
}
