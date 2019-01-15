//
//  RouteVC.swift
//  FlightSchedule
//
//  Created by Morris on 14/01/2019.
//  Copyright © 2019 Morris. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import Alamofire

class RouteVC: UIViewController {
    var departureAirport = ""
    var destinationAirport = ""
    var airline = ""
    var depLat = 0.0
    var depLong = 0.0
    var destLat = 0.0
    var destLong = 0.0
  @IBOutlet weak var routeMap: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDepAirportCoordinates(name: departureAirport)
        getDestAirportCoordinates(name: destinationAirport)
        
    }
    
    
    /*
     * getDepAirportCoordinates()
     * input departure airport name
     * computes the cordinates for departure airport
     */
    
    func getDepAirportCoordinates(name: String){
        for (_, object) in Config.sharedManager.Airports! {
            let airportCode = object["AirportCode"].stringValue
            if name == airportCode{
                 let position : JSON = JSON(object["Position"])
                 let coordinate : JSON = JSON(position["Coordinate"])
                guard let latitude = Double(coordinate["Latitude"].stringValue) else{
                    return
                }
                guard let longitude = Double(coordinate["Longitude"].stringValue) else{
                   return
                }
                 self.depLat = latitude
                 self.depLong = longitude
            }
            
        }
        
    }
    /*
     * getDestAirportCoordinates()
     * input destination airport
     * computes the cordinates for destination airport
     */
    func getDestAirportCoordinates(name: String){
        for (_, object) in Config.sharedManager.Airports! {
            let airportCode = object["AirportCode"].stringValue
            if name == airportCode{
                let position : JSON = JSON(object["Position"])
                let coordinate : JSON = JSON(position["Coordinate"])
                guard let latitude = Double(coordinate["Latitude"].stringValue) else{
                    return
                }
                guard let longitude = Double(coordinate["Longitude"].stringValue) else{
                    return
                }
                self.destLat = latitude
                self.destLong = longitude
            }
            
        }
        
        setupMapLocation()
        
    }
    
    
    /*
     * setupMapLocation()
     * sets up the map and shows a connection btwn the two points
     */
    func setupMapLocation(){
        //Draw a polyline between departure and destination
                let path = GMSMutablePath()
                path.addLatitude(self.depLat, longitude:self.depLong)
                path.addLatitude(self.destLat, longitude:destLong)
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = .blue
                polyline.strokeWidth = 3.0
                polyline.map = self.routeMap
        
        // set zoom position to departure
        let pos = GMSCameraPosition.camera(withLatitude: self.depLat,
                                           longitude: self.depLong,
                                           zoom: 6,
                                           bearing: 270,
                                           viewingAngle: 45)
        self.routeMap.camera = pos
        
     // animate zoom position to departure
      self.routeMap.animate(toLocation: CLLocationCoordinate2D(latitude: self.depLat, longitude: self.depLong))
        
            
            // Create a marker in the Departure
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.depLat, longitude: self.depLong)
            marker.title = self.departureAirport
            marker.snippet = self.departureAirport
            marker.map = self.routeMap
            
            //Destination
            let marker1 = GMSMarker()
            marker1.position = CLLocationCoordinate2D(latitude: self.destLat, longitude: self.destLong)
            marker1.title = self.destinationAirport
            marker1.snippet = self.destinationAirport
            marker1.map = self.routeMap
            
            
        }


    @IBAction func backAction(_ sender: Any) {
        let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleVC") as! ScheduleResultVC
        Switcher.navigateWithNavigationController(viewController: scheduleVC)
    }
    
}


