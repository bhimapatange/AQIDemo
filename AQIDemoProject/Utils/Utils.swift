//
//  constant.swift
//  AQIDemoProject
//
//  Created by Mayur on 01/12/21.
//

import Foundation
import UIKit
struct API {
    static let wsBaseUrl = "ws://city-ws.herokuapp.com/";
    static let timeInterval : TimeInterval = 10;
}

class CommonHelper {
    static func showAlertMeassage(message : String, controller : UIViewController){
            let alertContoller = UIAlertController (title: "Alert", message:message , preferredStyle: .alert)
            alertContoller.addAction(UIAlertAction(title: "OK", style:.default , handler: nil))
        controller.present(alertContoller , animated: true, completion: nil)
        }
}


enum AQIType: Int {
  case good
  case satisfactory
  case moderate
  case poor
  case veryPoor
  case severe
  
  init?(rawValue: Int) {
    switch rawValue {
    case 0...50: self = .good
    case 51...100: self = .satisfactory
    case 101...200: self = .moderate
    case 201...300: self = .poor
    case 301...400: self = .veryPoor
    default: self = .severe
    }
  }
  
  var color: UIColor {
    switch self {
    case .good:
      return UIColor(hex: "#55a951")
    case .satisfactory:
      return UIColor(hex: "#a3c852")
    case .moderate:
        return UIColor(hex: "#fef932")
    case .poor:
      return UIColor(hex: "#f29d33")
    case .veryPoor:
      return UIColor(hex: "#e93f35")
    case .severe:
      return UIColor(hex: "#af2c25")
    }
  }
  
  var title: String {
    switch self {
    case .good: return "Good"
    case .satisfactory: return "Satisfactory"
    case .moderate: return "Moderate"
    case .poor: return "Poor"
    case .veryPoor: return "Very Poor"
    case .severe: return "Severe"
    }
  }
  
  var notes: String {
    switch self {
    case .good: return "Open your windows to bring clean, fresh air indoors. Enjoy outdoor activities"
    case .satisfactory: return "Close your windows to avoid dirty outdoor air. Sensitive groups should reduce outdoor exercise"
    case .moderate: return "Sensitive groups should wear a mask outdoors. Close your windows to avoid dirty outdoor air. Everyone should reduce outdoor exercise. Run an air purifier"
    case .poor: return "Wear a mask outdoors. Close your windows to avoid dirty outdoor air. Avoid outdoor exercise. Run an air purifier"
    case .veryPoor: return "Wear a mask outdoors. Close your windows to avoid dirty outdoor air. Avoid outdoor exercise. Run an air purifier"
    case .severe: return "Wear a mask outdoors. Close your windows to avoid dirty outdoor air. Avoid outdoor exercise. Run an air purifier"
    }
  }
}
