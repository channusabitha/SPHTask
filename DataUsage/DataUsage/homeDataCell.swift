//
//  homeDataCell.swift
//  DataUsage
//
//  Created by ChannuSabitha on 9/6/19.
//  Copyright © 2019 SPHTech. All rights reserved.
//

import UIKit

class homeDataCell: UITableViewCell {

     @IBOutlet weak var LblYear:UILabel!
     @IBOutlet weak var LblQuaterData1:UILabel!
     @IBOutlet weak var LblQuaterData2:UILabel!
     @IBOutlet weak var LblQuaterData3:UILabel!
     @IBOutlet weak var LblQuaterData4:UILabel!
     @IBOutlet weak var LblTotalData:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
