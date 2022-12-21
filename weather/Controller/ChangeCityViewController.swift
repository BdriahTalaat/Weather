//
//  ChangeCityViewController.swift
//  weather
//
//  Created by Bdriah Talaat on 26/05/1444 AH.
//

import UIKit

class ChangeCityViewController: UIViewController {

    //MARK: OUTLET
    @IBOutlet weak var citiesPickerView: UIPickerView!
    
    //MARK: VARIABLE
    var cities = [City(name: "Riyadh", id: 108410),City(name: "Rabig", id: 1630254),City(name: "Makkah", id: 104514),City(name: "Jeddah", id: 105343),
                  City(name: "Dammam", id: 110336),City(name: "Tabuk", id: 101628),City(name: "Turabah", id: 101322),City(name: "Turaif", id: 101312),
                  City(name: "Yandu", id: 100425),City(name: "Najran", id: 103630),City(name: "Jizan", id: 105299),City(name: "Taif", id: 107968),
                  City(name: "Arar", id: 108512),City(name: "Medina", id: 109223),City(name: "Al Jumum", id: 109417),City(name: "Al Jawf", id: 109470),
                  City(name: "Afif", id: 110690),City(name: "Abha", id: 110690),City(name: "Al Hafuf", id: 109571),City(name: "Khobar", id: 109323)]
   
    var selectedCity : City?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        citiesPickerView.delegate = self
        citiesPickerView.dataSource = self
    }

    //MARK: ACTIONS
    @IBAction func DoneButton(_ sender: Any) {
        
        if let city = selectedCity{
            NotificationCenter.default.post(name: NSNotification.Name("cityValueChange"), object: nil , userInfo: ["city" : city])
            self.dismiss(animated: true)
        }
    }
    
}
//MARK: EZTENTION
extension ChangeCityViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cities[row]
    }
}
