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
    func weatherDidUpdate<T: Codable>(_ viewModel: WeatherViewModel, resultData: T)
    func weatherWithError(_ viewModel: WeatherViewModel, error: Error)
}

typealias delegateType = WeatherViewController & WeatherViewModelDelegate

class WeatherViewModel{
    
    weak var delegate: delegateType?
    
    //MARK: - openWeatherFatch
    //Fatch openWeather URL with cityName
    func weatherFatch(cityName: String){
        
        let urlString = "\(K.weatherURL)appid=\(K.apiKey)&q=\(cityName)"
        
        APICaller.shared.request(urlString: urlString, expecting: WeatherData.self) { result in
            switch result {
            case .success(let data):
                self.delegate?.weatherDidUpdate(self, resultData: data)
            case .failure(let error):
                self.delegate?.weatherWithError(self, error: error)
            }
        }
    }
    
    //Fatch openWeather URL with latitude and longitude
    func weatherFatch(lat: CLLocationDegrees, lon: CLLocationDegrees){
        
        let urlString = "\(K.weatherURL)lat=\(lat)&lon=\(lon)&appid=\(K.apiKey)"
        
        APICaller.shared.request(urlString: urlString, expecting: WeatherData.self) { []result in
            switch result {
            case .success(let data):
                self.delegate?.weatherDidUpdate(self, resultData: data)
            case .failure(let error):
                self.delegate?.weatherWithError(self, error: error)
            }
        }
    }

    //Fatch airPollution openWeather URL with latitude and longitude
    func airPollutionFatch(lat: Double, lon: Double){
        let urlString = "\(K.airPollutionURL)lat=\(lat)&lon=\(lon)&appid=\(K.apiKey)"
        
        APICaller.shared.request(urlString: urlString, expecting: AirPollutionData.self) { result in
            switch result {
            case .success(let data):
                self.delegate?.weatherDidUpdate(self, resultData: data)
            case .failure(let error):
                self.delegate?.weatherWithError(self, error: error)
            }
        }
    }

}
