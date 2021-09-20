//
//  ProviderManager.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import Foundation

struct ProviderManager{
    
    private let dataRepository = ProviderDataRepository()
    
    func create(record: Provider){
        
        dataRepository.create(record: record)
    }
    
    func getAllProviders() -> [Provider]?{
        
        return dataRepository.getAll()
    }
    
    func addProductToExistingProvider(provider: Provider, product: Product){
        
        dataRepository.addProductToExistingProvider(provider: provider, product: product)
    }
    
    func getProvider(byProvider name: String) -> Provider?{
        
        return dataRepository.get(byProvider: name)
    }
    
    func deleteProvider(record: Provider){
        
        dataRepository.delete(byProvider: record.providerName)
    }
}
