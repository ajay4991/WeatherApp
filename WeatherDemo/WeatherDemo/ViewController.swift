//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Vikramaditya Singh on 07/02/21.
//

import UIKit
import SideMenu
import SDWebImage

enum SelectedTempratureType {
    case F
    case C
}

class ViewController: UIViewController {
  
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tempratureValueLabel: UILabel!
    @IBOutlet weak var weatherTypeImageView: UIStackView!
    @IBOutlet weak var tempInfoLabel: UILabel!
    @IBOutlet weak var bottomScrollCollectionView: UICollectionView!
    @IBOutlet weak var logoLeftBarItem: UIBarButtonItem!
    @IBOutlet weak var weatherTypeImgView: UIImageView!
    @IBOutlet weak var fBtn: UIButton!
    @IBOutlet weak var cBtn: UIButton!
    
    var weatherData : WeatherData?

    var selectedTempratureType = SelectedTempratureType.C
    
    var collectionData = [["Min Max", "", "icon_temperature_info"],["Precipitation", "", "icon_precipitation_info"],["Humidity", "", "icon_humidity_info"],["Wind", "", "icon_wind_info"], ["Visibility", "", "icon_visibility_info"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService().get(url:"http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=395c6dcc3ded297741812cf192ab179a", parameters: [:]) { (data) in
            print("data: \(data)")
            self.weatherData = WeatherData(data: data)

            let minMax = "\(Int(self.weatherData?.minTemp ?? 0))° - \(Int(self.weatherData?.maxTemp ?? 0))°"
            self.collectionData = [["Min Max", minMax, "icon_temperature_info"],["Precipitation", "0%", "icon_precipitation_info"],["Humidity", "\(self.weatherData?.humidity ?? 0)", "icon_humidity_info"],["Wind", "\(self.weatherData?.wind ?? 0)", "icon_wind_info"], ["Visibility", "\(self.weatherData?.visibility ?? 0)", "icon_visibility_info"]]
            
            self.bottomScrollCollectionView.reloadData()
            self.setUI()
        }
        logoLeftBarItem.setBackgroundImage(UIImage(named: "logo.png"), for: .normal, barMetrics: .default)
        setupSideMenu()
        updateMenus()
        setupLayer()
        setelectedTempratureType()
        startTimer()
    
    }
    
    
    var countdownTimer = Timer()
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        dateTimeLabel.text = Date.getCurrentDate().uppercased()
    }

    
    func setUI() {
       
        let imageUrl = "http://openweathermap.org/img/w/\((self.weatherData?.icon ?? "")).png"
        weatherTypeImgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
        tempInfoLabel.text = (self.weatherData?.weatherDesciption ?? "").capitalized
        setelectedTempratureType()
        
    }
    
    func setelectedTempratureType() {
        
        let celsius = convertTemp(temp: (self.weatherData?.temp ?? 0), from: .kelvin, to: .celsius) // 18°C
        let fahrenheit = convertTemp(temp: (self.weatherData?.temp ?? 0), from: .kelvin, to: .fahrenheit) // 64°F
        
        if selectedTempratureType == .C {
            cBtn.backgroundColor = UIColor.white
            fBtn.backgroundColor = UIColor(rgb: 0xE8851CC)
            cBtn.setTitleColor(UIColor.orange, for: .normal)
            fBtn.setTitleColor(UIColor.white, for: .normal)
            tempratureValueLabel.text = "\(celsius)"
            
        }else {
             fBtn.backgroundColor = UIColor.white
             cBtn.backgroundColor = UIColor(rgb: 0xE8851CC)
             fBtn.setTitleColor(UIColor.orange, for: .normal)
             cBtn.setTitleColor(UIColor.white, for: .normal)
             tempratureValueLabel.text = "\(fahrenheit)"
        }
        
    }
    
    let mf = MeasurementFormatter()
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
      mf.numberFormatter.maximumFractionDigits = 0
      mf.unitOptions = .providedUnit
      let input = Measurement(value: temp, unit: inputTempType)
      let output = input.converted(to: outputTempType)
      return mf.string(from: output)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    func setupLayer(){
        
        bottomScrollCollectionView.clipsToBounds = false
        bottomScrollCollectionView.layer.masksToBounds = false
        
        bottomScrollCollectionView.layer.shadowColor = UIColor.white.cgColor
        bottomScrollCollectionView.layer.shadowOpacity = 1
        bottomScrollCollectionView.layer.shadowOffset = .zero
        bottomScrollCollectionView.layer.shadowRadius = 1

    }
    
    private func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController

        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    

    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }


    private func makeSettings() -> SideMenuSettings {
    
        var settings = SideMenuSettings()
        return settings
    }
    
    @IBAction func setTempartureTypeAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            selectedTempratureType = .C
        }else {
            selectedTempratureType = .F
        }
        setelectedTempratureType()
    }
    
    @IBAction func addToFavBtnAction(_ sender: Any) {
    }
    
}

extension ViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 2.75, height: collectionView.frame.size.height)
    }
    

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    

    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! BottomCollectionViewCell
        cell.topLabel.text = collectionData[indexPath.row][0]
        cell.bottomLabel.text = collectionData[indexPath.row][1]
        cell.imgView.image = UIImage.init(named: collectionData[indexPath.row][2])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

public class EdgeShadowLayer: CAGradientLayer {

    public enum Edge {
        case Top
        case Left
        case Bottom
        case Right
    }

    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 20.0,
                toColor: UIColor = UIColor.white,
                fromColor: UIColor = UIColor.black) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius

        let viewFrame = view.frame

        switch edge {
            case .Top:
                startPoint = CGPoint(x: 0.5, y: 0.0)
                endPoint = CGPoint(x: 0.5, y: 1.0)
                self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
            case .Bottom:
                startPoint = CGPoint(x: 0.5, y: 1.0)
                endPoint = CGPoint(x: 0.5, y: 0.0)
                self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width, height: shadowRadius)
            case .Left:
                startPoint = CGPoint(x: 0.0, y: 0.5)
                endPoint = CGPoint(x: 1.0, y: 0.5)
                self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
            case .Right:
                startPoint = CGPoint(x: 1.0, y: 0.5)
                endPoint = CGPoint(x: 0.0, y: 0.5)
                self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

class WeatherData {
    
    var temp : Double?
    var minTemp : Double?
    var maxTemp : Double?
    var perception : Double?
    var humidity : Double?
    var wind : Double?
    var visibility : Double?
    var weatherType : String?
    var weatherDesciption : String?
    var icon : String?
    
    init(data : [String : Any]) {
        
        if let main = data["main"] as? [String: Any] {
            self.temp = main["temp"] as? Double ?? 0
            self.minTemp = main["temp_min"] as? Double ?? 0
            self.maxTemp = main["temp_max"] as? Double ?? 0
            self.humidity = main["humidity"] as? Double ?? 0
        }
        if let wind = data["wind"] as? [String: Any] {
            self.wind = wind["speed"] as? Double ?? 0
        }
        if let weather = data["weather"] as? [[String: Any]] {
            self.weatherType = weather[0]["main"] as? String ?? ""
            self.weatherDesciption = weather[0]["description"] as? String ?? ""
            self.icon = weather[0]["icon"] as? String ?? ""
        }
        self.visibility = data["visibility"] as? Double ?? 0
    }
    
}

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy h:mm a"
        return dateFormatter.string(from: Date())
    }
}

//395c6dcc3ded297741812cf192ab179a

