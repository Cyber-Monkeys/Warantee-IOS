//
//  WaranteeCell.swift
//  warantee
//
//  Created by Humaid Khan on 13/12/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
// custom table view cell
class WaranteeCell: UITableViewCell {

    // has some ui elements that are set from table view controller
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var sellerNameLabel: UILabel!
    
    
    @IBOutlet weak var periodLabel: UILabel!
    
    
    @IBOutlet weak var waranteeImage: UIImageView!
    
    @IBOutlet weak var iconLabel: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
