//
//  ViewController.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import UIKit
import Kingfisher

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        weatherManager.delegate = self
        super.viewDidLoad()
        weatherManager.weatherFatch(cityName: "London")
    }
    
}

extension WeatherViewController: WeatherManagerDelegate{
    func weatherDidUpdate(_ weatherManager: WeatherManager, weatherData: WeatherData) {
        if let data = weatherData as? WeatherData{
            weatherManager.airPollutionFatch(lat: data.coord.lat, lon: data.coord.lon)
            let weatherModel = WeatherModel(weatherData: data)
            DispatchQueue.main.async {
                self.cityNameLabel.text = data.name
                self.temperatureLabel.text = "\(data.main.temp)°"
                self.minMaxTemperatureLabel.text = "H : \(data.main.temp_max)° L : \(data.main.temp_min)°"
                self.descriptionLabel.text = data.weather[0].description
                self.cloudinessLabel.text = "\(data.clouds.all) %"
                self.humidityLabel.text = "\(data.main.humidity) %"
                self.windSpeedLabel.text = "\(data.wind.speed) m/s"
                self.windDirectionLabel.text = weatherModel.windDirection
                self.weatherImage.kf.setImage(with: URL(string: weatherModel.imgUrlString), options: [.transition(.fade(1))])
            }
        }
    }
    func weatherWithError(_ weatherManager: WeatherManager, error: Error) {
        print(error)
    }
}
