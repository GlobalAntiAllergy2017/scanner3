//
//  DataApi.swift
//  Global Anti-Allergy
//
//  Created by uics15 on 11/11/17.
//  Copyright © 2017 Sarah Pisini. All rights reserved.
//

import Foundation




struct webdescription: Decodable{
    let code : String = ""
    let product : ProductScanned
    init (product:ProductScanned){
        self.product = product
    }
}
struct ProductScanned: Decodable{
    
    var product_name:String?
    let image_front_small_url:String?
    let ingredients_text_with_allergens: String?
    let image_url:String?
    let additives:String?
    var countries:String?
    let allergens:String?
    let brands:String?
    init (product_name:String,
          image_front_small_url:String,
          ingredients_text_with_allergens: String,
          image_url: String,
          additives: String,
          countries: String,
          allergens: String,
          brands: String) {
        self.product_name = product_name
        self.image_front_small_url = image_front_small_url
        self.ingredients_text_with_allergens = ingredients_text_with_allergens
        self.image_url = image_url
        self.additives = additives
        self.countries = countries
        self.allergens = allergens
        self.brands = brands
    }
}
