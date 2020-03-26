//
//  ViewController.swift
//  MinimalWeather
//
//  Created by DiMa on 04/03/2020.
//  Copyright © 2020 DiMa. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UICollectionViewDelegate{
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var launchScreenImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionPicture: UIImageView!
    @IBOutlet weak var weatherPicture: UIImageView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastCollectionView: UICollectionView!
    
    fileprivate var tableViewCellCoordinator: [Int: IndexPath] = [:]
    
    var weatherManager = WeatherManager()
    
    var weatherModel = WeatherModel(cityName: "", days: [], sunrise: 0.0, sunset: 0.0)
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        hourlyForecastCollectionView.delegate = self
        hourlyForecastCollectionView.dataSource = self
        
        dailyForecastCollectionView.delegate = self
        dailyForecastCollectionView.dataSource = self
        
        searchBar.delegate = self
        
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//        
        weatherPicture.image = UIImage(named: "ic_white_day_cloudy")
        temperatureIcon.image = UIImage(systemName: "thermometer")
        humidityIcon.image = UIImage(named: "ic_humidity")
        windIcon.image = UIImage(systemName: "wind")
        humidityIcon.image = humidityIcon.image?.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBar.textAlignment = .right
        searchBar.placeholder = "Search"
        searchBar.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        print(searchBar.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if searchBar.text != ""{
            return true
        } else {
            searchBar.placeholder = "Select a city"
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        textField.textAlignment = .left
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        
        self.weatherModel = weather
        //        if let timeResult = (weather.sunrise as? Double) {
        //            let date = Date(timeIntervalSince1970: timeResult)
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        //            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        //            dateFormatter.timeZone = .current
        //            let localDate = dateFormatter.string(from: date)
        //            print(localDate)
        //        }
        print("didUpdateWeather")
        
        DispatchQueue.main.async {
            //                        self.temperatureLabel.text = "\(weather.timeSlotsArray[0].temperatureString)°C"
            //                        self.weatherPicture.image = UIImage(systemName: weather.timeSlotsArray[0].conditionName)
            //                        self.windDirectionPicture.image = UIImage(systemName: weather.timeSlotsArray[0].windDirectionArrow)
            self.searchBar.text = weather.cityName
            self.searchBar.textAlignment = .left
            self.temperatureLabel.text = "\(weather.days[0].timeSlotsDictionary[0]!.temperatureString)°C"
            self.weatherPicture.image = UIImage(systemName: weather.days[0].timeSlotsDictionary[0]!.conditionName)
            self.windDirectionPicture.image = UIImage(systemName: weather.days[0].timeSlotsDictionary[0]!.windDirectionArrow)
            self.dateLabel.text = ("\(weather.days[0].timeSlotsDictionary[0]!.dayOfTheWeek), \(weather.days[0].timeSlotsDictionary[0]!.dayOfTheMonth) \(weather.days[0].timeSlotsDictionary[0]!.month)")
            self.hourlyForecastCollectionView.reloadData()
            self.dailyForecastCollectionView.reloadData()
            self.launchScreenImage.isHidden = true

            //            self.temperaturesDictionary
            //            print(weather.timeSlotsArray[0].date)
            //            print(weather.timeSlotsArray[0].dateArray)
            //            print(weather.timeSlotsArray[0].dayOfTheWeek)
            
            //            let date = Date()
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "EEEE"
            //            let dayOfTheWeekString = dateFormatter.string(from: date)
            //            print(dayOfTheWeekString)
            
            
            
        }
    }
    
    func didFailWithError(_ error: Error){
        print(error)
    }
}


extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.hourlyForecastCollectionView{
            if weatherModel.days.count != 0{
                var numberOfSections = 0
                for i in weatherModel.days{
                    numberOfSections += i.timeSlotsDictionary.count
                }
                return numberOfSections
            } else {
                return 10
            }
        } else {
            if weatherModel.days.count != 0{
                return weatherModel.days.count
            } else {
                return 10
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.hourlyForecastCollectionView {
            let hourlyForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCollectionViewCell", for: indexPath) as! HourlyDataCollectionViewCell
            
            DispatchQueue.main.async{
                if self.weatherModel.days.count != 0{
                    
                    var CVM: Int{
                        switch indexPath.row {
                        case ...self.weatherModel.days[0].timeSlotsDictionary.keys.max()!:
                            return 0
                        case ...self.weatherModel.days[1].timeSlotsDictionary.keys.max()!:
                            return 1
                        case ...self.weatherModel.days[2].timeSlotsDictionary.keys.max()!:
                            return 2
                        case ...self.weatherModel.days[3].timeSlotsDictionary.keys.max()!:
                            return 3
                        case ...self.weatherModel.days[4].timeSlotsDictionary.keys.max()!:
                            return 4
                        default:
                            return 5
                        }
                    }
                    
                    hourlyForecastCell.temperatureLabel.text = self.weatherModel.days[CVM].timeSlotsDictionary[indexPath.row]?.temperatureString
                    hourlyForecastCell.weatherConditionUIImage.image = UIImage(systemName: self.weatherModel.days[CVM].timeSlotsDictionary[indexPath.row]?.conditionName ?? "sun")
                    hourlyForecastCell.hourLabel.text = self.weatherModel.days[CVM].timeSlotsDictionary[indexPath.row]?.hour
                }
            }
            return hourlyForecastCell
            
        } else {
            let dailyForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForecastCollectionViewCell", for: indexPath as IndexPath) as! DayForecastCollectionViewCell
            
            if self.weatherModel.days.count != 0{
                dailyForecastCell.dayLabel.text = weatherModel.days[indexPath.row].dayOfTheWeek
                dailyForecastCell.temperatureLabel.text = "\(weatherModel.days[indexPath.row].maximumTemperature)°/\(weatherModel.days[indexPath.row].minimumTemperature)°"
                dailyForecastCell.weatherPicture.image = UIImage(systemName: weatherModel.days[indexPath.row].timeSlotsDictionary.first!.value.conditionName)
                
            }
            
            
            //            if let layout = hourlyForecastCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //                layout.scrollDirection = .vertical
            //            }
            
            return dailyForecastCell
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got a location")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("No location. sorry.\(error)")
    }
}
//// UICollectionViewDataSource
//
//extension WeatherViewController: UICollectionViewDataSource,
//UICollectionViewDelegateFlowLayout {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCollectionViewCell", for: indexPath) as! HourlyDataCollectionViewCell
//            return cell
//    }
//}
//
//// UICollectionViewDelegate
//
//extension WeatherViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("selected collectionViewCell with indexPath: \(indexPath) in tableViewCell with indexPath: \(tableViewCellCoordinator[collectionView.tag]!)")
//    }
//}
