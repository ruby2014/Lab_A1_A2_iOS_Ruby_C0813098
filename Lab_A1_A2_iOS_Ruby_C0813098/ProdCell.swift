//
//  ProdCell.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import UIKit

class ProdCell: UITableViewCell {

    @IBOutlet weak var lblProdName: UILabel!
    
    @IBOutlet weak var lblProdDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var prodPrice: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //this function to show values of the selected product in the cell columns
    func setProdCell (product: Product){
        lblProdName.text=product.productName
        lblProdDescription.text=product.provider?.providerName
        
        
    }

}
