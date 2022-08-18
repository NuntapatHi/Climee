//
//  ViewController.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import UIKit

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
        let weatherModel = WeatherModel(weatherData: weatherData)
        DispatchQueue.main.async {
            self.cityNameLabel.text = weatherData.name
            self.temperatureLabel.text = "\(weatherData.main.temp)°"
            self.minMaxTemperatureLabel.text = "H : \(weatherData.main.temp_max)° L : \(weatherData.main.temp_min)°"
            self.descriptionLabel.text = weatherData.weather[0].description
            self.cloudinessLabel.text = "\(weatherData.clouds.all) %"
            self.humidityLabel.text = "\(weatherData.main.humidity) %"
            self.windSpeedLabel.text = "\(weatherData.wind.speed) m/s"
            self.windDirectionLabel.text = weatherModel.windDirection
            
            self.weatherImage.loadWithURL(urlString: weatherModel.imgUrlString)
        }
    }
    func weatherWithError(_ weatherManager: WeatherManager, error: Error) {
        print(error)
    }
}
