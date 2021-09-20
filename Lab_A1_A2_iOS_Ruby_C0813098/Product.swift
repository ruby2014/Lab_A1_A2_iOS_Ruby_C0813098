//
//  Product.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import Foundation

class Product{
    
    let id: String
    let name: String
    let description: String
    let price: String
    let providerName: String
    let provider: Provider?
    
    init(id: String, name: String, description: String, price: String, providerName: String, provider: Provider? = nil) {
        
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.providerName = providerName
        self.provider = provider
    }
}
