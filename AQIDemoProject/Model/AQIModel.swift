//
//  AQIModel.swift
//  AQIDemoProject
//
//  Created by Mayur on 01/12/21.
//

import Foundation
import UIKit

struct AQIModel {
  let city: String
    let aqi : Double
  let aqiValue: String
  let aqiType: AQIType
}


extension AQIModel: Decodable {
  enum CodingKeys: String, CodingKey {
    case city, aqi
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    city = try values.decode(String.self, forKey: .city)
    let result = try values.decode(Double.self, forKey: .aqi)
    aqiValue = String(format: "%.2f", result)
    aqiType = AQIType(rawValue: Int(result)) ?? .good
    aqi = result
  }
}

extension AQIModel: Equatable {}

func ==(lhs: AQIModel, rhs: AQIModel) -> Bool {
  return lhs.city == rhs.city
}
