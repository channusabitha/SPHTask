//
//  dataVC.swift
//  DataUsage
//
//  Created by ChannuSabitha on 9/7/19.
//  Copyright © 2019 SPHTech. All rights reserved.
//

import UIKit

class dataVC: NSObject {
    
    var yearStr : NSString?
    var q1Data : Double?
    var q2Data : Double?
    var q3Data : Double?
    var q4Data : Double?
    var total : Double?
    
   func getTotal(){
    
    self.total = self.q1Data!+self.q2Data! + self.q3Data!+self.q4Data!
    
    }

}
