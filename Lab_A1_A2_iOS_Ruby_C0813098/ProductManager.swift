//
//  ProductManager.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import Foundation

struct ProductManager{
    
    private let dataRepository = ProductDataRepository()
    
    func create(record: Product){
        
        dataRepository.create(record: record)
    }
    
    func getAllProducts() -> [Product]?{
        
        return dataRepository.getAll()
    }
    
    func getProduct(byProduct id: String) -> Product?{
        
        return dataRepository.get(byProduct: id)
    }
    
    func updateProduct(record: Product){
        
        dataRepository.updateProduct(record: record)
    }
    
    func deleteProduct(record: Product){
        
        dataRepository.delete(byIdentifier: record.id)
    }
}
