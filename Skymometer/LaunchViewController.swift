//
//  LaunchViewController.swift
//  Skymometer
//
//  Created by Максим Соловьёв on 13.01.2021.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        presentWeatherVC()
    }
    
    private func presentWeatherVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
