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
    
    @IBOutlet weak var ImgAQIImageView: UIImageView!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var indexAQILabel: UILabel!
    @IBOutlet weak var descriptionAQILabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private let viewModel = WeatherViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarController(true, animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBarController(false, animated)
        
    }
    
    private func setUp(){
        viewModel.delegate = self
        searchBar.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        moreInfoButton.isEnabled = false
        self.dismissKeybaordWhenTouchAround()
        
    }
    
    private func setNavigationBarController(_ hidden: Bool, _ animated: Bool){
        guard let navBarController = navigationController else {
            print("Could not found navigationController.")
            return
        }
        
        navBarController.setNavigationBarHidden(hidden, animated: animated)
        
    }
    
    
    @IBAction func moreInfoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.weatherToForcastIndentifier, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? WeatherForcastTableViewController else {
            print("Could not prepare segue.")
            return
        }
        
        guard let viewModelweatherData = viewModel.weatherData else {
            print("Could not found weatherData in WeatherViewModel.")
            return
        }
        
        destinationVC.weatherData = viewModelweatherData
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
        print("Something go wrong : \(error) -> \(error.localizedDescription)")
    }
}

//MARK: - WeatherManagerDelegates
extension WeatherViewController: WeatherViewModelDelegate{
    func didUpdateWithWeatherData(data: WeatherData) {
        
        viewModel.airPollutionFatch(lat: data.coord.lat, lon: data.coord.lon)
        
        let weatherModel = WeatherModel(weatherData: data)
        let primaryBackgroundColor = UIColor(named: weatherModel.themeBackgroundColor[0])
        let secondaryBackgroundColor = UIColor(named: weatherModel.themeBackgroundColor[1])
        
        DispatchQueue.main.async { [weak self] in
            //Change theme background color with weather codition
            self?.mainView.backgroundColor = primaryBackgroundColor
            self?.cloudinessCardView.backgroundColor = secondaryBackgroundColor
            self?.humidityCardView.backgroundColor = secondaryBackgroundColor
            self?.windCardView.backgroundColor = secondaryBackgroundColor
            self?.visibilityCardView.backgroundColor = secondaryBackgroundColor
            self?.aqiCardView.backgroundColor = secondaryBackgroundColor
            self?.locationButton.tintColor = secondaryBackgroundColor
            
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
            self?.moreInfoButton.isEnabled = true
        }
    }
    
    func didUpdateWithError(error: Error) {
        print("Something go wrong : \(error) -> \(error.localizedDescription)")
        DispatchQueue.main.async { [weak self] in
            self?.moreInfoButton.isEnabled = false
        }
    }
    
}
