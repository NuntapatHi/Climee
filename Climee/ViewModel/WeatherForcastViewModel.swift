//
//  WeatherForcastViewModel.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 20/12/2565 BE.
//

import Foundation

enum formatType{
    case date
    case time
}

protocol WeatherForcastDelegate{
    func didUpdateWithForcastData()
    func didUpdateWithError(_ error: Error)
}

class WeatherForcastViewModel{
    
    var weatherForcastData: WeatherForcastData?
    var delegate: WeatherForcastDelegate?
    func weatherForcastFetch(cityName: String){
        
        let urlString = "\(K.weatherForcastURL)appid=\(K.apiKey)&q=\(cityName)"
        
        APICaller.shared.request(urlString: urlString, expecting: WeatherForcastData.self) {[weak self] result in
            switch result{
            case .success(let forcastData):
                self?.weatherForcastData = forcastData
                self?.delegate?.didUpdateWithForcastData()
            case .failure(let error):
                self?.delegate?.didUpdateWithError(error)
            }
        }
        
    }
    
    func dateFormat(formatType: formatType, _ dateString: String) -> String{
        
        let dateFormatter = DateFormatter()
        var formattedTimeString = ""
        if formatType == .time{
            dateFormatter.dateFormat = "HH:mm:ss"

            guard let date = dateFormatter.date(from: dateString) else {
                print("invalid time string")
                return "--:--"
            }

            dateFormatter.dateFormat = "HH:mm"
            formattedTimeString = dateFormatter.string(from: date)
        } else if formatType == .date{
            dateFormatter.dateFormat = "yyyy-MM-dd"

            guard let date = dateFormatter.date(from: dateString) else {
                print("invalid time string")
                return "-/--/----"
            }

            dateFormatter.dateFormat = "dd/MM/yyyy"
            formattedTimeString = dateFormatter.string(from: date)
        } else {
            return "N/A"
        }
        
        return formattedTimeString
        
    }
}
