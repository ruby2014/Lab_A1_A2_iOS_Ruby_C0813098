//
//  Provider.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import Foundation

import Foundation

class Provider{
    
    let providerName: String
    var product : [Product]?
    
    init(providerName: String, product: [Product]?) {
        
        self.providerName = providerName
        self.product = product
    }
}
