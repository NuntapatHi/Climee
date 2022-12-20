//
//  WeatherViewModel.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 12/11/2565 BE.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherViewModelDelegate{
    func didUpdateWithWeatherData(data: WeatherData)
    func didUpdateWithAirPollutionData(data: AirPollutionData)
    func didUpdateWithError(error: Error)
}

class WeatherViewModel{
    
    var delegate: WeatherViewModelDelegate?
    var weatherData: WeatherData?
    
    //MARK: - openWeatherFatch
    //Fatch openWeather URL with cityName
    func weatherFatch(cityName: String){
        
        let urlString = "\(K.weatherURL)appid=\(K.apiKey)&q=\(cityName)"
        
        APICaller.shared.request(urlString: urlString, expecting: WeatherData.self) { [weak self] result in
            switch result {
            case .success(let weatherData):
                //weatherUpdateData
                self?.delegate?.didUpdateWithWeatherData(data: weatherData)
                self?.weatherData = weatherData
            case .failure(let error):
                //weatherWithError
                self?.delegate?.didUpdateWithError(error: error)
            }
        }
    }
    
    //Fatch openWeather URL with latitude and longitude
    func weatherFatch(lat: CLLocationDegrees, lon: CLLocationDegrees){
        
        let urlString = "\(K.weatherURL)lat=\(lat)&lon=\(lon)&appid=\(K.apiKey)"
        
        APICaller.shared.request(urlString: urlString, expecting: WeatherData.self) { [weak self]result in
            switch result {
            case .success(let weatherData):
                self?.delegate?.didUpdateWithWeatherData(data: weatherData)
                self?.weatherData = weatherData
            case .failure(let error):
                self?.delegate?.didUpdateWithError(error: error)
            }
        }
    }

    //Fatch airPollution openWeather URL with latitude and longitude
    func airPollutionFatch(lat: Double, lon: Double){
        let urlString = "\(K.airPollutionURL)lat=\(lat)&lon=\(lon)&appid=\(K.apiKey)"
        
        APICaller.shared.request(urlString: urlString, expecting: AirPollutionData.self) { result in
            switch result {
            case .success(let airPollutionData):
                self.delegate?.didUpdateWithAirPollutionData(data: airPollutionData)
            case .failure(let error):
                self.delegate?.didUpdateWithError(error: error)
            }
        }
    }

}
