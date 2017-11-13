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
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCountry: UILabel!
    @IBOutlet weak var theLocation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
                        self.imageView.image = UIImage(data: data)
                    }
                    }.resume()
                } else {
                    DispatchQueue.main.async {
                        self.productName.text = webDescription.product.product_name
                        self.productCountry.text = webDescription.product.countries
                    }
                }
            } catch let jsonErr {
                print ("error serializinf json:", jsonErr)
                
            }
            }.resume()
    }


}
