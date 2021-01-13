//
//  WeatherViewController.swift
//  Skymometer
//
//  Created by Максим Соловьёв on 13.01.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let mainView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "main")
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let weatherIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "xmark.icloud.fill")
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont(name: "Copperplate", size: 30)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "0°C"
        label.font = UIFont(name: "Copperplate", size: 60)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()

    
    let feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Feels like: 0°C"
        label.font = UIFont(name: "Copperplate", size: 20)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    var networkManager = NetworkManager()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else {return}
            self.updateInterface(weather: currentWeather)
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
    }
    
    func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString)°C"
            self.feelsLikeTemperatureLabel.text = "Feels like: \(weather.feelsLikeTemperatureString)°C"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
    @objc func didTapSearchButton() {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    private func setupConstraints() {
        
        view.addSubview(mainView)
        mainView.addSubview(weatherIconImageView)
        mainView.addSubview(temperatureLabel)
        mainView.addSubview(feelsLikeTemperatureLabel)
        mainView.addSubview(searchButton)
        mainView.addSubview(cityLabel)
        
        [mainView,
         temperatureLabel,
         weatherIconImageView,
         searchButton,
         cityLabel,
         feelsLikeTemperatureLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 200),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 200),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            feelsLikeTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            feelsLikeTemperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor),
            feelsLikeTemperatureLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor),
            feelsLikeTemperatureLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            cityLabel.heightAnchor.constraint(equalToConstant: 50),
            cityLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
        
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping(String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["Moscow", "London", "Saint-Peterburg", "Berlin", "Paris"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
