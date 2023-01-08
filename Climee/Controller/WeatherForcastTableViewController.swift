//
//  WeatherForcastTableViewController.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 20/12/2565 BE.
//

import UIKit
import Kingfisher

class WeatherForcastTableViewController: UITableViewController{
    
    private let viewModel = WeatherForcastViewModel()
    var weatherModel: WeatherModel?{
        didSet{
            tableView.backgroundColor = UIColor(named: (weatherModel?.themeBackgroundColor[0])!)
        }
    }
    var weatherData: WeatherData?{
        didSet{
            self.weatherModel = WeatherModel(weatherData: weatherData!)
            guard let cityName = weatherData?.name else {
                print("Could not found city name.")
                return
            }
            title = cityName
            viewModel.weatherForcastFetch(cityName: cityName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherForcastData?.list.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.forcastCell, for: indexPath) as? ForcastTableViewCell,
                let data = viewModel.weatherForcastData?.list[indexPath.row], let weatherModel = weatherModel
        else {
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            cell.textLabel?.text = "No data forcast."
            return cell
        }
        cell.backgroundColor = UIColor(named: weatherModel.themeBackgroundColor[1])
        let dateAndTime = data.dt_txt.components(separatedBy: " ")
        
        cell.conditionImageView.kf.setImage(with: URL(string: "\(K.weatherImgURL)\(data.weather[0].icon)@2x.png"), options: [.transition(.fade(1))])
        cell.dateLabel.text = viewModel.dateFormat(formatType: .date, dateAndTime[0])
        cell.timeLabel.text = viewModel.dateFormat(formatType: .time, dateAndTime[1])
        cell.temperatureLabel.text = "\(data.main.temp)°C"
        cell.humidityLabel.text = "\(data.main.humidity)%"
        cell.cloudinessLabel.text = "\(data.clouds.all)%"
        cell.descriptionLabel.text = data.weather[0].description.capitalizingFirstLetter()
        return cell
        
    }
}

extension WeatherForcastTableViewController: WeatherForcastDelegate{

    func didUpdateWithForcastData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func didUpdateWithError(_ error: Error) {
        print("Something go wrong : \(error) -> \(error.localizedDescription)")
    }
}
