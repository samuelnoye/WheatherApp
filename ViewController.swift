//
//  ViewController.swift
//  WheatherApp
//
//  Created by Samuel Noye on 20/04/2022.
//



import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var skinLbl: UILabel!
    var skintype = SkinType().type1 {
        didSet{
            skinLbl.text = "Skin: " + self.skintype
            Utilities().setSkinType(value: skintype)
        }
    }
    var uvIndex = "8"
    
    let locationManager = CLLocationManager()
    var coords = CLLocationCoordinate2D(latitude: 40, longitude: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        skintype = Utilities().getSkinType()
        skinLbl.text = "Skin: " + self.skintype
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Do any additional setup after loading the view.
    
    }
    @IBAction func changeSkinBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Skin Type", message: "Please choose skin type!", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: SkinType().type1, style: .default, handler: { (action) in
            self.skintype = SkinType().type1
        }))
        alert.addAction(UIAlertAction(title: SkinType().type2, style: .default, handler: { (action) in
            self.skintype = SkinType().type2
        }))
        alert.addAction(UIAlertAction(title: SkinType().type3, style: .default, handler: { (action) in
            self.skintype = SkinType().type3
        }))
        alert.addAction(UIAlertAction(title: SkinType().type4, style: .default, handler: { (action) in
            self.skintype = SkinType().type4
        }))
        alert.addAction(UIAlertAction(title: SkinType().type5, style: .default, handler: { (action) in
            self.skintype = SkinType().type5
        }))
        alert.addAction(UIAlertAction(title: SkinType().type6, style: .default, handler: { (action) in
            self.skintype = SkinType().type6
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       // print("Location changed")
        
        if status == .authorizedWhenInUse {
            getLocation()
            //print("fdhf")
        }else if status == .denied {
            let alert = UIAlertController(title: "Error", message: "Go to seettings and allow app to access your location! App can't function without it!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getLocation() {
        if let loc = locationManager.location?.coordinate {
            coords = loc
            getWeatherData()
        }
    }
    func getWeatherData() {
        let url = WeatherUrl(lat: String(coords.latitude), long: String(coords.longitude)).getFullUrl()
        print(url)
        Alamofire.request(url).responseJSON{ response in
            print("Alamofire: \(response.result)")
            if let JSON = response.result.value {
                print(JSON)

                if let dictionary = JSON as? [String: AnyObject], let data = dictionary["data"] as? [String: AnyObject]{
                    if let weather = data["weather"] as? [Dictionary<String, AnyObject>]{
                        if let uvI = weather[0]["uvIndex"] as? String {
                            self.uvIndex = uvI
                        }
                    }
                }
                
                
                
                
                
                
            }
    }
    }
}

