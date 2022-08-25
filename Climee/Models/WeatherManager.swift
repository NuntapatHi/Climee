//
//  WeatherManager.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import Foundation
import UIKit
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
    
    let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&"

    let apikey = "addac5760d2063966c0f5102171286c7"
    
    func weatherFatch(cityName: String){
        var urlString = "\(K.weatherURL)appid=\(K.apiKey)&q=\(cityName)"
        
        request(urlString: urlString, expecting: WeatherData.self) { result in
            switch result {
            case .success(let data):
                delegate?.weatherDidUpdate(self, resultData: data)
            case .failure(let error):
                delegate?.weatherWithError(self, error: error)
            }
        }
    }
    
    func airPollutionFatch(lat: Float, lon: Float){
        var urlString = "\(K.airPollutionURL)lat=\(lat)&lon=\(lon)&appid=\(K.apiKey)"
        print(urlString)
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
