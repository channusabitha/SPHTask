//
//  Common.swift

import UIKit

class CommonTask: NSObject {

    static var commonObj : CommonTask?
    
    class var task: CommonTask {
        
        if commonObj == nil{
            commonObj = CommonTask()
        }
        return commonObj!
    }
    
    
    /// Alert view
    
    func showAlert(_ title: String, message: String, vc: UIViewController) -> Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    //To check the network connectivity
    func hasConnectivity() -> Bool {
        
        let reachability: Reachability
        do {
            reachability =  Reachability()!
        } catch {
            return false
        }
        if reachability.currentReachabilityStatus == Reachability.NetworkStatus.notReachable {
            return false
        }else {
            return true
            
        }
        
    }
    
}
