//
//  HomeVC.swift
//  DataUsage
//
//  Created by ChannuSabitha on 9/6/19.
//  Copyright © 2019 SPHTech. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var homeTV:UITableView!
    var arrData : [AnyObject]?
    var dataDict: NSDictionary?
    var yearDict: NSDictionary?
    var myFinalArray=[[String  :Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getData()
    }
    
    // MARK: Private Methods
    
     func getData(){
        
   //  https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=5
        
        let url = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=20"
        
        
     UrlConnection.sharedConnection().loadData(fromUrl: url, withPostbody: [:], httpMethod: "GET") { (responseDict, statusCode) in
    
           self.dataDict = (responseDict["result"] as! NSDictionary)
           self.arrData = self.dataDict!["records"] as? [AnyObject]
            print(self.arrData!)
           var previousYearStr = "0"
           var q1="0",q2="0",q3="0",q4="0"
        
        for var yearData in self.arrData! {
            let year = yearData["quarter"] as? String
            print(year!)
            
            var strArray = year?.components(separatedBy: "-")
            
            let dYear = strArray![0]
            let dQuater = strArray![1]
             if (previousYearStr == "0")
             {
                previousYearStr=dYear
             }
            
            if(dYear != previousYearStr)
            {
                let dict = ["Year":previousYearStr ,"Q1":q1 ,"Q2":q2,"Q3":q3,"Q4":q4 ] as [String :String]
                self.myFinalArray.append(dict)
                q1="0"
                q2="0"
                q3="0"
                q4="0"
                previousYearStr = dYear
            }
            
            if(dQuater == "Q1")
            {
                q1 = (yearData["volume_of_mobile_data"] as? String)!
            }
            else if(dQuater == "Q2")
            {
               q2 = (yearData["volume_of_mobile_data"] as? String)!
            }
            else if(dQuater == "Q3")
            {
                q3 = (yearData["volume_of_mobile_data"] as? String)!
            }
            else if(dQuater == "Q4")
            {
                q4 = (yearData["volume_of_mobile_data"] as? String)!
            }
        }
        
        print(self.myFinalArray)
        
           self.homeTV.dataSource = self
           self.homeTV.delegate = self
           self.homeTV.reloadData()

        }
    }

    // MARK:
    // MARK: TableView DataSource Methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.myFinalArray.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 128
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let identifier = "homeDataCell"
        var cell: homeDataCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? homeDataCell
        if cell == nil {
            tableView.register(UINib(nibName: "homeDataCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? homeDataCell
        }
        
         let dataYearDict = self.myFinalArray[indexPath.row]
        
         cell.LblYear.text = dataYearDict["Year"] as? String
         cell.LblQuaterData1.text = dataYearDict["Q1"] as? String
         cell.LblQuaterData2.text = dataYearDict["Q2"] as? String
         cell.LblQuaterData3.text = dataYearDict["Q3"] as? String
         cell.LblQuaterData4.text = dataYearDict["Q4"] as? String

        let numberFormatter = NumberFormatter()
     
        let quater1 = numberFormatter.number(from: dataYearDict["Q1"] as! String)?.floatValue
        let quater2 = numberFormatter.number(from: dataYearDict["Q2"] as! String)?.floatValue
        let quater3 = numberFormatter.number(from: dataYearDict["Q3"] as! String)?.floatValue
        let quater4 = numberFormatter.number(from: dataYearDict["Q4"] as! String)?.floatValue

        let total = quater1!+quater2!+quater3!+quater4!
        
        cell.LblTotalData.text = "\(total)"
    
        return cell
    }
    
    // MARK:
    // MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = homeTV.cellForRow(at: indexPath) as! homeDataCell
        let data = cell.LblTotalData.text
        let year = cell.LblYear.text
        CommonTask.task.showAlert("Total Data Used in" + " " + year! + " is " + data!, message: "", vc: self)
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
