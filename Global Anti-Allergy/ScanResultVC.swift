//
//  ScanResultVC.swift
//  Global Anti-Allergy
//
//  Created by boyuan on 11/9/17.
//  Copyright © 2017 Sarah Pisini. All rights reserved.
//

import UIKit
import CoreLocation




class ScanResultVC: UIViewController, CLLocationManagerDelegate {
    
    var theBarcodeString:String?
    var thePicUrl: String?
    var theProduct: ProductScanned?
    var theTextLabel: String?
    var theCountryLabel: String?
    var allergentList:[String] = ["peanut","nut","treenut"]
    var productIngrediants: String?
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCountry: UILabel!
    @IBOutlet weak var theLocation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var allergentResult: UITextField!
    
    /*let theManager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation = locations[0]
        CLGeocoder().reverseGeocodeLocation(myLocation) { (placemark, error) in
            if error == nil {
                if let place = placemark?[0]{
                    self.theLocation.text = place.thoroughfare
                }
            }
     }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*theManager.delegate = self
        theManager.requestWhenInUseAuthorization()
        theManager.desiredAccuracy = kCLLocationAccuracyBest
        theManager.startUpdatingLocation()*/
    }
    override func viewWillAppear(_ animated: Bool) {
        let jsonUrlString = "https://world.openfoodfacts.org/api/v0/product/"+theBarcodeString!+".json"
        guard let url = URL(string:jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let data = data else{return}
            do {
                let webDescription = try JSONDecoder().decode(webdescription.self, from: data)
                self.thePicUrl = webDescription.product.image_url
                if self.thePicUrl != nil {
                guard let theimageUrl = URL(string:self.thePicUrl!) else {return}
                URLSession.shared.dataTask(with: theimageUrl){ (data, response, error) in
                    guard let data = data else{return}
                    DispatchQueue.main.async {
                        self.productName.text = webDescription.product.product_name
                        self.productCountry.text = webDescription.product.countries
                        
                        if webDescription.product.ingredients_text_with_allergens != nil {
                            self.productIngrediants = webDescription.product.ingredients_text_with_allergens
                            self.allergentResult.text = self.allergentlistcheck(ingredient: self.productIngrediants!, allergents: self.allergentList)
                        }
                        
                        self.imageView.image = UIImage(data: data)
                    }
                    }.resume()
                } else {
                    DispatchQueue.main.async {
                        self.productName.text = webDescription.product.product_name
                        self.productCountry.text = webDescription.product.countries
                        
                        //same chunk
                        if webDescription.product.ingredients_text_with_allergens != nil {
                            self.productIngrediants = webDescription.product.ingredients_text_with_allergens
                            self.allergentResult.text = self.allergentlistcheck(ingredient: self.productIngrediants!, allergents: self.allergentList)
                        }
                    }
                }
            } catch let jsonErr {
                print ("error serializinf json:", jsonErr)
                
            }
            }.resume()
    }
    
    
    func allergentlistcheck( ingredient: String, allergents:[String]) -> String{
        var result:String = ""
        for stringx in allergents{
            if booleansearchallergentEng(ingredients: ingredient, allergent: stringx){
                result = "contains " + stringx + "\n" + result
            }
        }
        if (result == ""){
            result = "No allergent source found"
        }
        return result
    }
    
    //method for check allergent contents
    func booleansearchallergentEng( ingredients: String, allergent:String) -> Bool {
        let ingredientArr = ingredients.components(separatedBy: [":", ",", " "])
        for (Stringx) in ingredientArr{
            if (Stringx == allergent){
                return true
            }
        }
        return false
    }
    func booleansearchallergent( ingredients: String, allergent: String, language: String) -> Bool{
        let ingredientArr = ingredients.components(separatedBy: [":", ",", " "])
        let keyword: [String] = translate(allergent: allergent, Languagename: language)
        for (Stringx) in ingredientArr{
            for (Stringy) in keyword{
                if (Stringx == Stringy){
                    return true
                }
            }
        }
        return false
    }
    
    //inner method of above
    func translate(allergent: String, Languagename: String) -> [String]{
        if (Languagename == "French")&&(allergent == "peanut"){
            return ["cacahuète","arachide"]
        }
        else if (Languagename == "French") && (allergent == "diary"){
            return ["lait","laitier","crémerie"]
        }
        else if (Languagename == "German") && (allergent == "peanut"){
            return ["Erdnuss","Nuss" ]
        }
        else if (Languagename == "German") && (allergent == "diary"){
            return["Milch","Molkerei"]
        }
        return [""]
    }
    
    


}
