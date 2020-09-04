//
//  Model.swift
//  SmokerMap
//
//  Created by 정의석 on 2020/03/09.
//  Copyright © 2020 pandaman. All rights reserved.
//

import Foundation
import UIKit

struct smokingArea {
    let xPos: String
    let yPos: String
    let address: String
    let name: String
    let isInside: Bool
    let roof: Bool
    let bench: Bool
    let memo: String
}

struct Day {
    let day: String
    let cigaretteNum: Int
}
struct Month {
    let days: [Day]
    let month: String
}
struct Year {
    let months: [Month]
    let year: String
}

struct SmokingArea {
  let name: String
  let lat: Double
  let lng: Double
  let isInside: Bool
  let uid: String
  let spaceSzie: String
}



