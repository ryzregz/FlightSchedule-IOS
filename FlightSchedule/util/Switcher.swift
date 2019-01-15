//
//  Switcher.swift
//  FlightSchedule
//
//  Created by Eclectics on 15/01/2019.
//  Copyright © 2019 Eclectics. All rights reserved.
//

import Foundation
import UIKit
class Switcher{
    static func navigate(viewController: UIViewController?){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
    }
    
    static func navigateWithNavigationController(viewController: UIViewController){
        let rootVC = UINavigationController(rootViewController: viewController)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
}
