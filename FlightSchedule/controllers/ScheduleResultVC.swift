//
//  ScheduleResultVC.swift
//  FlightSchedule
//
//  Created by Morris on 14/01/2019.
//  Copyright © 2019 Morris. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import ProgressHUD

class ScheduleResultVC: UIViewController {

    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    @IBOutlet weak var departureBtn: UIButton!
    @IBOutlet weak var destinationBtn: UIButton!
     @IBOutlet weak var notifyText: UILabel!
    let chooseDepAirport = DropDown()
    let chooseDestAirport = DropDown()
    var airportNames = [String]()
    
    let reuseIdentifier = "ScheduleCell"
    var scheduleList = [Schedule]()
    var schedule: [Schedule]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scheduleCollectionView.dataSource = self
        scheduleCollectionView.delegate = self
        getToken()
        chooseDepAirport.anchorView = departureBtn
        chooseDestAirport.anchorView = destinationBtn
        chooseDepAirport.selectionAction = { [unowned self] (index: Int, item: String) in
            self.departureBtn.setTitle("\(item)",for: .normal)
        }
        
        chooseDestAirport.selectionAction = { [unowned self] (index: Int, item: String) in
            self.destinationBtn.setTitle("\(item)",for: .normal)
        }
        
    }

    @IBAction func findClicked(_ sender: UIButton) {
        self.findSchedule()
    }
    
    @IBAction func originClicked(_ sender: UIButton) {
        chooseDepAirport.show()
    }
    
    @IBAction func destClicked(_ sender: UIButton) {
        chooseDestAirport.show()
    }
    
    
    func getToken(){
        ApiService.generateTokenRequest(onSuccess: { (data) in
            print("Data \(data)")
            Config.sharedManager.auth_token = data["access_token"].stringValue
            self.getAirports()
        }) { (error) in
            print("Error \(String(describing: error))")
        }
    }
    
    func getAirports(){
        ApiService.getRequest(method: "references/airports", onSuccess: { (data) in
            print("Airport Data \(data)")
            self.handleAirportResponse(data: data)
        }) { (error) in
            print("Error \(String(describing: error))")
        }
        
    }
    
    func handleAirportResponse(data: JSON){
        let airportResource : JSON = JSON(data["AirportResource"])
        let airportObject : JSON = JSON(airportResource["Airports"])
         let airports: JSON = JSON(airportObject["Airport"])
         Config.sharedManager.Airports = airports
        for (_, object) in airports {
            let airportCode = object["AirportCode"].stringValue
            self.airportNames.append(airportCode)
        }
        
        chooseDepAirport.dataSource = self.airportNames
        chooseDestAirport.dataSource = self.airportNames
        
        
        
    }
    
    func findSchedule(){
        self.notifyText.isHidden = true
        //get departure airport code from the selector and unwrap the optional value
        guard let departure = departureBtn.currentTitle, departure != "" else{
            print("Departure Airport is Required")
            return
        }
        //get destination airport code from the selector unwrap the optional value
       guard let destination = destinationBtn.currentTitle, destination != "" else{
            print("Destination Airport is Required")
            return
        }
        
        //set Search Date to current Date
        let date = Date()
        let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let currDate = formatter.string(from: date)
        let api_method = "operations/schedules/\(departure)/\(destination)/\(currDate)?directFlights=0"
        
        //Send Api Request
         ProgressHUD.show("Retreiving Schedule..", interaction: true)
        ApiService.getRequest(method: api_method, onSuccess: { (data) in
            ProgressHUD.showSuccess()
            print("Schedule Data  \(data)")
            //handle Flight Schedule Response
            self.handleScheduleResponse(data:data)
            
        }) { (error) in
            print("Error \(String(describing: error))")
            ProgressHUD.showError(String(describing: error))
        }
    }
    
    func handleScheduleResponse(data:JSON){
        if data["ScheduleResource"].exists(){
            
            let scheduleResource : JSON = JSON(data["ScheduleResource"])
            let schedule : JSON = JSON(scheduleResource["Schedule"])
            for (_, object) in schedule {
                let flight : JSON = JSON(object["Flight"])
                for(_,obj) in flight{
                    
                    //departure object
                    let departure : JSON = JSON(obj["Departure"])
                    let scheduledTime : JSON = JSON(departure["ScheduledTimeLocal"])
                    let departureTime = scheduledTime["DateTime"].stringValue
                    let departureAirport = departure["AirportCode"].stringValue
                    
                    //arrival object
                    let arrival : JSON = JSON(obj["Arrival"])
                    let arrivalscheduledTime : JSON = JSON(arrival["ScheduledTimeLocal"])
                    let arrivalTime = arrivalscheduledTime["DateTime"].stringValue
                    let arrivalAirport = arrival["AirportCode"].stringValue
                    
                    //airline object
                    let airline : JSON = JSON(obj["MarketingCarrier"])
                    let airlineID = airline["AirlineID"].stringValue
                    let flightNo = airline["FlightNumber"].stringValue
                    
                    self.scheduleList.append(Schedule(departureTime: departureTime, arrivalTime: arrivalTime, departureAirport: departureAirport, arrivalAirport: arrivalAirport, airline: airlineID, flightNo: flightNo))
                    
                }
                self.schedule = self.scheduleList
                DispatchQueue.main.async {
                    self.scheduleCollectionView.reloadData()
                }
            }
            
        }else{
            let errorResource : JSON = JSON(data["ProcessingErrors"])
            let errorObject : JSON = JSON(errorResource["ProcessingError"])
            let error = errorObject["Description"].stringValue
              ProgressHUD.showError(error)
        }
        
        
        
    }
}
extension ScheduleResultVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = schedule {
            return schedule!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ScheduleCellCollectionViewCell
        cell.schedule = self.schedule?[indexPath.row]
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor(red: 243/255, green: 240/255, blue: 240/255, alpha: 1.0).cgColor
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red: 243/255, green: 240/255, blue: 240/255, alpha: 1.0).cgColor
        cell.layer.masksToBounds = true
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius : cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let routeVC = self.storyboard?.instantiateViewController(withIdentifier: "routeVC") as! RouteVC
        routeVC.departureAirport = (self.schedule?[indexPath.row].departureAirport)!
        routeVC.destinationAirport = (self.schedule?[indexPath.row].arrivalAirport)!
        Switcher.navigateWithNavigationController(viewController: routeVC)
        
    }
    
    
}
