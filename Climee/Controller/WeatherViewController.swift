//
//  ViewController.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 16/8/2565 BE.
//

import Foundation
import UIKit
import Kingfisher
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cloudinessCardView: UIView!
    @IBOutlet weak var humidityCardView: UIView!
    @IBOutlet weak var windCardView: UIView!
    @IBOutlet weak var visibilityCardView: UIView!
    @IBOutlet weak var aqiCardView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var cloudinessValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var visibilityValue: UILabel!
    
    @IBOutlet weak var ImgAQIImageView: UIImageView!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var indexAQILabel: UILabel!
    @IBOutlet weak var descriptionAQILabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var viewModel = WeatherViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        viewModel.delegate = self
        searchBar.delegate = self
        locationManager.delegate = self
        self.dismissKeybaordWhenTouchAround()
    }
}

//MARK: - SearchBarDelegates
extension WeatherViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            searchBar.resignFirstResponder()
        }
        else {
            if let cityName = searchBar.text{
                viewModel.weatherFatch(cityName: cityName)
                searchBar.text = ""
                searchBar.resignFirstResponder()
            }
        }
    }
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            viewModel.weatherFatch(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
//MARK: - WeatherManagerDelegates
extension WeatherViewController: WeatherViewModelDelegate{
    func didUpdateWithWeatherData(data: WeatherData) {
        
        viewModel.airPollutionFatch(lat: data.coord.lat, lon: data.coord.lon)
        let weatherModel = WeatherModel(weatherData: data)
        
        DispatchQueue.main.async { [weak self] in
            //Change theme background color with weather codition
            self?.mainView.backgroundColor = UIColor(named: weatherModel.themeBackgroundColor[0])
            self?.cloudinessCardView.backgroundColor = UIColor(named: weatherModel.themeBackgroundColor[1])
            self?.humidityCardView.backgroundColor = UIColor(named: weatherModel.themeBackgroundColor[1])
            self?.windCardView.backgroundColor = UIColor(named: weatherModel.themeBackgroundColor[1])
            self?.visibilityCardView.backgroundColor = UIColor(named: weatherModel.themeBackgroundColor[1])
            self?.aqiCardView.backgroundColor = UIColor(named: weatherModel.themeBackgroundColor[1])
            self?.locationButton.tintColor = UIColor(named: weatherModel.themeBackgroundColor[1])
            
            //set up weather data
            self?.cityNameLabel.text = "\(data.name), \(data.sys.country)"
            self?.temperatureLabel.text = "\(data.main.temp)°C"
            self?.minMaxTemperatureLabel.text = "H : \(data.main.temp_max)°C | L : \(data.main.temp_min)°C"
            self?.descriptionLabel.text = data.weather[0].description.capitalizingFirstLetter()
            self?.weatherImage.kf.setImage(with: URL(string: weatherModel.imgUrlString), options: [.transition(.fade(1))])
            self?.cloudinessValueLabel.text = "\(data.clouds.all) %"
            self?.humidityValueLabel.text = "\(data.main.humidity) %"
            self?.windValueLabel.text = "\(data.wind.speed) m/s"
            self?.windDirectionLabel.text = weatherModel.windDirection
            self?.visibilityValue.text = "\(weatherModel.visibilityDistance) km"
            
        }
        
    }
    
    func didUpdateWithAirPollutionData(data: AirPollutionData) {
        
        let airPollutionModel = AirPollutionModel(airPollutionData: data)
        
        DispatchQueue.main.async { [weak self] in
            
            // Set up airPollution data
            self?.ImgAQIImageView.image = UIImage(named: airPollutionModel.statusAQI[0])
            self?.pmLabel.text = "PM2.5 (\(data.list[0].components.pm2_5))"
            self?.indexAQILabel.text = airPollutionModel.statusAQI[1]
            self?.descriptionAQILabel.text = airPollutionModel.statusAQI[2]
            self?.ImgAQIImageView.backgroundColor = UIColor(named: airPollutionModel.statusAQI[3])
            
        }
    }
    
    func didUpdateWithError(error: Error) {
        print("Something go wrong : \(error) -> \(error.localizedDescription)")
    }
    
}
