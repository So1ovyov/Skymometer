//
//  LaunchViewController.swift
//  Skymometer
//
//  Created by Максим Соловьёв on 13.01.2021.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "S K Y M O M E T E R"
        label.font = UIFont(name: "Copperplate", size: 34)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let sun: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sun")
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    let sky: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "sky")
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAnimation()
        presentWeatherVC()
    }
    
    private func setupConstraints() {
        
        view.addSubview(label)
        view.addSubview(sun)
        view.addSubview(sky)
        
        [label,
         sun,
         sky].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            sun.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sun.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sun.widthAnchor.constraint(equalToConstant: 200),
            sun.heightAnchor.constraint(equalToConstant: 200),
            sun.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            sky.widthAnchor.constraint(equalToConstant: 150),
            sky.heightAnchor.constraint(equalToConstant: 150),
            sky.leadingAnchor.constraint(equalTo: sun.leadingAnchor, constant: 60),
            sky.bottomAnchor.constraint(equalTo: sun.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.byValue = 1 * -CGFloat.pi
        rotation.duration = 6
        rotation.repeatCount = Float.greatestFiniteMagnitude
        sun.layer.add(rotation, forKey: "myAnimation")
    }
    
    private func presentWeatherVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let vc = WeatherViewController()
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.fade
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

}
