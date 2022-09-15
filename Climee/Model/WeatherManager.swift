//
//  WeatherManager.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import Foundation
import UIKit
import CoreLocation
protocol WeatherManagerDelegate{
    func weatherDidUpdate<T: Codable>(_ weatherManager: WeatherManager, resultData: T)
    func weatherWithError(_ weatherManager: WeatherManager, error: Error)
}

enum CustomError: Error{
    case invalidURL
    case invalidData
}

struct WeatherManager{
    
    var delegate: WeatherManagerDelegate?
    
    //MARK: - openWeatherFatch
    //Fatch openWeather URL with cityName
    func weatherFatch(cityName: String){
        
        let urlString = "\(K.weatherURL)appid=\(K.apiKey)&q=\(cityName)"
        
        request(urlString: urlString, expecting: WeatherData.self) { result in
            switch result {
            case .success(let data):
                delegate?.weatherDidUpdate(self, resultData: data)
            case .failure(let error):
                delegate?.weatherWithError(self, error: error)
            }
        }
    }
    
    //Fatch openWeather URL with latitude and longitude
    func weatherFatch(lat: CLLocationDegrees, lon: CLLocationDegrees){
        
        let urlString = "\(K.weatherURL)lat=\(lat)&lon=\(lon)&appid=\(K.apiKey)"
        
        request(urlString: urlString, expecting: WeatherData.self) { result in
            switch result {
            case .success(let data):
                delegate?.weatherDidUpdate(self, resultData: data)
            case .failure(let error):
                delegate?.weatherWithError(self, error: error)
            }
        }
    }
    
    //Fatch airPollution openWeather URL with latitude and longitude
    func airPollutionFatch(lat: Double, lon: Double){
        let urlString = "\(K.airPollutionURL)lat=\(lat)&lon=\(lon)&appid=\(K.apiKey)"
        
        request(urlString: urlString, expecting: AirPollutionData.self) { result in
            switch result {
            case .success(let data):
                delegate?.weatherDidUpdate(self, resultData: data)
            case .failure(let error):
                delegate?.weatherWithError(self, error: error)
            }
        }
    }
    
    
    func request<T: Codable>(urlString: String, expecting: T.Type, completions: @escaping (Result<T, Error>) -> Void){
        guard let url = URL(string: urlString) else {
            completions(.failure(CustomError.invalidURL))
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completions(.failure(error))
                } else {
                    completions(.failure(CustomError.invalidData))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completions(.success(result))
            } catch {
                completions(.failure(error))
            }
        }
        task.resume()
    }
}
