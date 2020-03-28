//
//  TimeSlotModel.swift
//  MinimalWeather
//
//  Created by DiMa on 22/03/2020.
//  Copyright © 2020 DiMa. All rights reserved.
//

import Foundation

struct TimeSlotModel {
    let date: String
    let conditionID: Int
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let windDirection: Int
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701:
            return "cloud.fog"
        case 711...771:
            return "smoke"
        case 781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud.sun"
        }
    }
    
    var windDirectionArrow: String{
        switch windDirection {
        case 23...67:
            return "arrow.up.right"
        case 68...112:
            return "arrow.up"
        case 112...157:
            return "arrow.up.left"
        case 157...202:
            return "arrow.left"
        case 202...247:
            return "arrow.down.left"
        case 248...292:
            return "arrow.down"
        case 292...337:
            return "arrow.down.right"
        default:
            return "arrow.right"
        }
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var dateArray: [String] {
        return date.split{ !$0.isNumber }.map{String($0)}
    }
    
    var hour: String {
        return dateArray[3]
    }
    
    var dayOfTheWeek: String {
        let daysOfTheWeek = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let todayDate = formatter.date(from: date)!
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return daysOfTheWeek[weekDay]
    }
    
    var dayOfTheMonth: String {
        return dateArray[2]
    }
    
    var month: String {
        switch dateArray[1] {
        case "01":
            return "January"
        case "02":
            return "February"
        case "03":
            return "March"
        case "04":
            return "April"
        case "05":
            return "May"
        case "06":
            return "June"
        case "07":
            return "July"
        case "08":
            return "August"
        case "09":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return "No month like that"
        }
    }
    
    
    
}
