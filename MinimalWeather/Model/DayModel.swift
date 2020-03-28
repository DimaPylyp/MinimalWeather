//
//  DayModel.swift
//  MinimalWeather
//
//  Created by DiMa on 24/03/2020.
//  Copyright © 2020 DiMa. All rights reserved.
//

import Foundation

struct DayModel {
    
    var date: String
    var timeSlotsDictionary: [Int: TimeSlotModel]
    var minimumTemperature: String
    var maximumTemperature: String
    
    
    var dayOfTheWeek: String {
        let daysOfTheWeek = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayDate = formatter.date(from: date)!
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return daysOfTheWeek[weekDay]
    }}
