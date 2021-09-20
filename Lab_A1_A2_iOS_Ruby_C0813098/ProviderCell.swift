//
//  ProviderCell.swift
//  Lab_A1_A2_iOS_Ruby_C0813098
//
//  Created by Mac on 2021-09-20.
//

import UIKit

class ProviderCell: UITableViewCell {

    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblProviderCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //this function to show values of the selected product in the cell columns
    func setProviderCell (provider: Providers){
        
           
       lblProviderName.text=provider.providerName
        lblProviderCount.text = "\(provider.products?.count ?? 0)"
        
        
    }


}
