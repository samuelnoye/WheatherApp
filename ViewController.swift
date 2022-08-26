//
//  ViewController.swift
//  WheatherApp
//
//  Created by Samuel Noye on 20/04/2022.
//



import UIKit
import MapKit
import Alamofire
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var burnTimeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var skinLbl: UILabel!
    var skintype = SkinType().type1 {
        didSet{
            skinLbl.text = "Skin: " + self.skintype
            Utilities().setSkinType(value: skintype)
            getWeatherData()
            print("run..",)
        }
    }
    var uvIndex = 8
    var burnTime: Double = 10
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
        print("hbdfh")
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
    
    @IBAction func remindMeBtn(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Time's up", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "you are beginning to burn! Please put on sunblock, clothing or get under shelter!", arguments: nil)
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "willburn", content: content, trigger: trigger)
                
                center.add(request)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            getLocation()
        }else if status == .denied {
            let alert = UIAlertController(title: "Error", message: "Go to seettings and allow app to access your location! App can't function without it!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getLocation() {
        if let loc = locationManager.location?.coordinate {
            coords = loc
         }
    }
    
    func getWeatherData() {
        let url = WeatherUrl(lat: String(coords.latitude), long: String(coords.longitude)).getFullUrl()
        print(url)
        Alamofire.request(url).responseJSON{ response in
            print("Alamofire: \(response.result)")
            if let JSON = response.result.value {
                print(JSON)
                
                //                if let dictionary = JSON as? [String: AnyObject], let data = dictionary["data"] as? [String: AnyObject]{
                //                    if let weather = data["weather"] as? [Dictionary<String, AnyObject>]{
                //                        if let uvI = weather[0]["uvIndex"] as? String {
                //                            self.uvIndex = uvI
                //                        }
                //                    }
                //                }
                //
                guard let dictionary = JSON as? [String: AnyObject], let data = dictionary["data"] as? [String: AnyObject], let weather = data["weather"] as? [Dictionary<String, AnyObject>], let uv = weather[0]["uvIndex"] as? String, let uvI = Int(uv) else {
                    self.UpdtaeUI(dataSuccess: false)
                    return
                }
                self.uvIndex = uvI
                print("AT LAST UV INDEX: \(uvI)")
                self.UpdtaeUI(dataSuccess: true)
                return
            }
        }
    }
    
    func UpdtaeUI (dataSuccess: Bool ){
        DispatchQueue.main.async {
            if !dataSuccess {
                self.statusLbl.text = "Failed...retrying..."
                self.getWeatherData()
                return
            }
            self.activityIndicator.stopAnimating()
            self.statusLbl.text = "Data Available"
            self.CalculateBurnTime()
            print("BurnTime: \(self.burnTime)")
            self.burnTimeLbl.text = String(self.burnTime)
        }
    }
    
    func CalculateBurnTime(){
        var minToBurn: Double = 10
        
        switch skintype {
        case SkinType().type1:
            minToBurn = BurnTime().burType1
        case SkinType().type2:
            minToBurn = BurnTime().burType2
        case SkinType().type3:
            minToBurn = BurnTime().burType3
        case SkinType().type4:
            minToBurn = BurnTime().burType4
        case SkinType().type5:
            minToBurn = BurnTime().burType5
        case SkinType().type6:
            minToBurn = BurnTime().burType6
        default:
            minToBurn = BurnTime().burType1
        }
        burnTime = minToBurn / Double(self.uvIndex)
    }
}


