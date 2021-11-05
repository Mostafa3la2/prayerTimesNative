//
//  ViewController.swift
//  PrayerTime
//
//  Created by Mostafa on 25/01/2021.
//

import UIKit
import Moya
import CoreLocation
class ViewController: UIViewController {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
    }


}
extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let prayerProvide = MoyaProvider<PrayerServices>()
        prayerProvide.request(.getPrayersByLatLong(lat: String(locValue.latitude), long: String(locValue.longitude), tomorrow: false)) { (result) in
            switch result{
            case .success(let response):
                let decoder = JSONDecoder()
                do{
                    let prayerModel = try decoder.decode(prayerTimeModel.self, from: response.data)
                    print(prayerModel.data?.timings)
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error)
            }
            
        }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
