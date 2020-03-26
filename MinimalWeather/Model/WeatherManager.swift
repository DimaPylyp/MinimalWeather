//
//  WeatherManager.swift
//  MinimalWeather
//
//  Created by DiMa on 06/03/2020.
//  Copyright © 2020 DiMa. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=64b22b90859a5d6b73fa0fb20e87e21e&units=metric"
    
    var delegate: WeatherManagerDelegate?

    
    func fetchWeather (cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        print (urlString)
    }
    
    func fetchWeather (latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        print (urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print (error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
                task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            var timeSlotsArray: [TimeSlotModel] = []
            for i in decodedData.list{
                let date = i.dt_txt
                let conditionID = i.weather[0].id
                let temperature = i.main.temp
                let humidity = i.main.humidity
                let windSpeed = i.wind.speed
                let windDirection = i.wind.deg
                
                let timeSlot = TimeSlotModel(date: date, conditionID: conditionID, temperature: temperature, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection)
                
                timeSlotsArray.append(timeSlot)
            }
            
            var days: [DayModel] = []
            var previousDay = ""
            var numberOfADay = 0
            var numberOfSlot = 0

            for i in timeSlotsArray{
                print(i.hour, i.dayOfTheWeek)
                if i.dayOfTheWeek != previousDay{
                let date = i.date
                    print("created")
                    days.append(DayModel(date: date, timeSlotsDictionary: [:], minimumTemperature: "", maximumTemperature: ""))
                    numberOfADay += 1
                    days[numberOfADay - 1].timeSlotsDictionary[numberOfSlot] = i
                    numberOfSlot += 1
                    previousDay = i.dayOfTheWeek
                } else {
                    print("added")
                    days[numberOfADay - 1].timeSlotsDictionary[numberOfSlot] = i
                    var temperaturesArray: [Double] = []
                    for i in days[numberOfADay - 1].timeSlotsDictionary{
                        temperaturesArray.append(i.value.temperature)
                    }
                    numberOfSlot += 1
                    days[numberOfADay - 1].minimumTemperature = String(Int(temperaturesArray.min() ?? 0))
                    print("minimus is:\(days[numberOfADay - 1].minimumTemperature)")
                    days[numberOfADay - 1].maximumTemperature = String(Int(temperaturesArray.max() ?? 0))
                    print("maximum is:\(days[numberOfADay - 1].maximumTemperature)")
                }
            }
            
           
            
            let name = decodedData.city.name
            let sunrise = decodedData.city.sunrise
            let sunset = decodedData.city.sunset
            
            let weather = WeatherModel(cityName: name, days: days, sunrise: sunrise, sunset: sunset)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
    
}

