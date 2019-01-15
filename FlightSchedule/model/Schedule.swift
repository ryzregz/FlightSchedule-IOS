//
//  Schedule.swift
//  FlightSchedule
//
//  Created by Morris on 14/01/2019.
//  Copyright © 2019 Morris. All rights reserved.
//

import Foundation
class Schedule{
    var departureTime = ""
    var arrivalTime = ""
    var departureAirport = ""
    var arrivalAirport = ""
    var airline = ""
    var flightNo = ""
    
    init(departureTime:String,arrivalTime:String,departureAirport:String,arrivalAirport:String,airline:String, flightNo:String){
        self.airline = airline
        self.arrivalAirport = arrivalAirport
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.departureAirport = departureAirport
        
    }
}
