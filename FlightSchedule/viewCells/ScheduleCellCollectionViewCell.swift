//
//  ScheduleCellCollectionViewCell.swift
//  FlightSchedule
//
//  Created by Morris on 14/01/2019.
//  Copyright © 2019 Morris. All rights reserved.
//

import UIKit

class ScheduleCellCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var airlineName: UILabel!
     @IBOutlet weak var departureAirport: UILabel!
     @IBOutlet weak var arrivalAirport: UILabel!
     @IBOutlet weak var departureTime: UILabel!
     @IBOutlet weak var arrivalTime: UILabel!
    
    
    var schedule: Schedule!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.airlineName.text = schedule.airline
        self.arrivalAirport.text = schedule.arrivalAirport
        self.arrivalTime.text = schedule.arrivalTime
        self.departureAirport.text = schedule.departureAirport
        self.departureTime.text = schedule.departureTime
    }
    
    
    
   
    
    
}
