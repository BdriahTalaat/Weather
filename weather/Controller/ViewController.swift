//
//  ViewController.swift
//  weather
//
//  Created by Bdriah Talaat on 28/03/1444 AH.
//

import UIKit
import Alamofire
import SwiftyJSON
import BonsaiController
import NVActivityIndicatorView

class ViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var feelLikeView: UIView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: VARIABEL
    var weather = [Weather]()
    var id = "1630254"
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feelLikeView.layer.cornerRadius = feelLikeView.frame.height/4
        pressureView.layer.cornerRadius = pressureView.frame.height/4
        humidityView.layer.cornerRadius = humidityView.frame.height/4
        
        NotificationCenter.default.addObserver(self, selector: #selector(cityChange), name: NSNotification.Name("cityValueChange"), object: nil)
        
        loaderView.startAnimating()
        getWeather()
        
    }
    
    //MARK: FUNCTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        segue.destination.transitioningDelegate = self
        segue.destination.modalPresentationStyle = .custom
        
    }
    
    @objc func cityChange(notification : Notification){
        if let city = notification.userInfo?["city"] as? City{
            cityNameLabel.text = city.name
            id = "\(city.id)"
            getWeather()
        }
    }
    
    func getWeather(){
        let URL = "https://api.openweathermap.org/data/2.5/weather"
        let params = ["id" : id, "appid":"a8ea7c277721f7511e6cdf01269da243"]

        AF.request(URL,parameters: params,encoder: URLEncodedFormParameterEncoder.default).responseJSON { [self] response in

            if let result = response.value{
                let JSONDictionary = result as! NSDictionary
                let main = JSONDictionary["main"] as! NSDictionary

                var pressure = main["pressure"] as! Int
                var temp = main["temp"] as! Double
                var feelsLike = main["feels_like"] as! Double
                var humidity = main["humidity"] as! Int

                feelsLike = feelsLike - 272.15
                feelsLike = round(feelsLike)
                temp = temp - 272.15
                temp = round(temp)

                tempLabel.text = "\(Int(temp))°"
                humidityLabel.text = "\(humidity)%"
                pressureLabel.text = "\(pressure) hPa"
                feelsLikeLabel.text = "\(Int(feelsLike))°"
            }

            let jsonData = JSON(response.value)
            let data = jsonData["weather"]
            let decoder = JSONDecoder()

            do{
                weather = try decoder.decode([Weather].self, from: data.rawData())
                descriptionLabel.text = weather[0].description
                loaderView.stopAnimating()
            }catch let error{
                print(error)
            }
        }
    }


}
//MARK: EXTENTION FOR CUSTOM SIZE VIEW CONTROLLER
extension ViewController: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 2), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / 2))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
        /// With Background Color ///
    
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
        
    }
}

