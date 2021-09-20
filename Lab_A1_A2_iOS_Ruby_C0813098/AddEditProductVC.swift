//
//  AddEditProductVC.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import UIKit
import CoreData


// Protocaol to call methods from Listing View Controller
protocol saveData {
    func  updateProduct(pId : Int , pName : String , pDes : String , pPrice :Double ,pProvider :String, selectedProvider :Providers?)
    func deleteProduct(product: Product)
    func deleteProvider(provider: Providers)
}

class AddEditProductVC: UIViewController {

    
    @IBOutlet weak var textFieldProductName: UITextField!
    
    @IBOutlet weak var textFieldProductId: UITextField!
    
    @IBOutlet weak var textFieldProvider: UITextField!
    
    @IBOutlet weak var textFieldPrice: UITextField!
    
    @IBOutlet weak var textFieldDescription: UITextField!

    var selectedProduct: Product?{
        didSet {
            editMode = true
        }
    }
    
    // edit mode by default is false
    var editMode: Bool = false
    
    // instance of sava data protocol
    var  delegate : saveData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedProduct != nil){
            //Set Selected Product Data in textFields
            textFieldProductId.text =  String (selectedProduct!.productId)
            textFieldProductName.text = selectedProduct?.productName
            textFieldProvider.text = selectedProduct?.provider?.providerName
            textFieldDescription.text = selectedProduct?.productDescription
            textFieldPrice.text =  String (selectedProduct!.productPrice)
        }
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectedProduct=nil
    }
 
    @IBAction func onCancelClick() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
      
        
      
        let proId = Int (textFieldProductId.text ?? "0") ??  0
        let proName = textFieldProductName.text ?? ""
        let proPrice = Double (textFieldPrice.text ?? "0.0") ?? 0.0
        let proDescription = textFieldDescription.text ?? ""
        let proProvider = textFieldProvider.text ?? ""
        
        if (proId != 0 || proName != "" || proPrice != 0 || proProvider != "" || proDescription != ""){
              if editMode {
                self.delegate?.deleteProduct(product:  selectedProduct!)
                // call update product with provider detail in case of edit product
                  self.delegate?.updateProduct(pId: proId, pName: proName, pDes: proDescription, pPrice: proPrice, pProvider: proProvider, selectedProvider : (selectedProduct?.provider)!)
              }else{
                // Add new product in core data
                self.delegate?.updateProduct(pId: proId, pName: proName, pDes: proDescription, pPrice: proPrice, pProvider: proProvider, selectedProvider : nil )
              }
            self.dismiss(animated: false, completion: nil)
        }
      
    }
    
}
