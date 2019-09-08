//
//  UrlConnection.swift

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class UrlConnection: NSObject {

    var myDelegate: AppDelegate?
    var sessionConfigaration : URLSessionConfiguration?
    var sessionTask = URLSessionDataTask()
    
    
   static var connection: UrlConnection?
    
    
   class func sharedConnection() -> UrlConnection {
        
        if (self.connection == nil) {
            self.connection = UrlConnection()
        }
        return self.connection!
    
    }
    
    class func newConnection() -> UrlConnection {
        self.connection = UrlConnection()
        return self.connection!
    }
    
    override init() {
        self.myDelegate = UIApplication.shared.delegate as? AppDelegate
        self.sessionConfigaration = URLSessionConfiguration.default
        self.sessionConfigaration?.httpAdditionalHeaders = ["Content-Type"  : "application/json"]
    }
    
    
    func cancelRequestIfany(){
        
        if self.sessionTask.state == URLSessionTask.State.running {
            self.sessionTask.cancel()
        }
    }
  
    //REad data from API and retuns the response
    func loadData(fromUrl urlString: String, withPostbody postDict:Dictionary<String, AnyObject>?, httpMethod method:String, withCompletionblock completionblock: @escaping (_ responseDict :Dictionary<String, AnyObject>, _ statusCode: Int) -> Void) {
        
        print("urlString--->\(urlString)")
        
        if CommonTask.task.hasConnectivity() == false {
        
            UrlConnection.show(message: "Internet connection appears to be offline.", controller: self.myDelegate!.navigationController!)
            
            return
        }
        
        let encodedUrl = urlString.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let session = URLSession(configuration: self.sessionConfigaration!)
        
        // Convert Url string to NSUrl
        
        let url = URL(string: encodedUrl!)
        
        /// Create Mutable Url request instance and set properties
        
        var mutableRequest = URLRequest(url: url!)
        
        mutableRequest.httpMethod = method
        

        self.sessionTask = session.dataTask(with: mutableRequest, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async(execute: {

                if error == nil {
                    
                    let httpResponse = response as? HTTPURLResponse
                    let httpHeasers = httpResponse?.allHeaderFields
                    let statusCode = httpResponse?.statusCode
                    
                    if statusCode >= 200 && statusCode < 300 {
                        
                        var responseData : Any?
                        do {
                            responseData =  try JSONSerialization.jsonObject(with: data!, options: [])
                        } catch {
                        }
                        
                        var responseDic: [AnyHashable: Any]?
                        
                        if responseData == nil {
                            
                            CommonTask.task.showAlert("Could not connect to server", message: "", vc: self.myDelegate!.navigationController!)

                        }else {
                            
                            print("responseData--->\(String(describing: responseData!))")

                            var message : String? = ""

                            if responseData! is Array<Any> {
                                responseDic = ["response" : responseData!]
                            }else {
                                responseDic = responseData as? Dictionary
                            }
                            message = responseDic!["userMessage"] as? String

                            print("Response--->\(String(describing: responseDic))")
                            
                            if urlString.range(of: "open?") != nil || urlString.range(of: "close?") != nil{
                                completionblock(responseDic! as! Dictionary<String, AnyObject>, statusCode!)
                                return
                            }


                            if message == nil {
                                completionblock(responseDic! as! Dictionary<String, AnyObject>, statusCode!)
                            }else {
                                CommonTask.task.showAlert(message! as String, message: "", vc: self.myDelegate!.navigationController!)
                            }
                            
                        }
                        
                        
                    }else if statusCode == 401 {
            
                            completionblock(["code" : "401" as AnyObject], statusCode!)

                        }else {
                            self.myDelegate!.navigationController?.popToRootViewController(animated: true)
                        }
    
                    }else {
                        
                        
                        
                        var responseData : Any?
                        do {
                            responseData =  try JSONSerialization.jsonObject(with: data!, options: [])
                        } catch {
                        }
                        
                        var responseDic: [AnyHashable: Any]?
                        
                        if responseData == nil {
                            CommonTask.task.showAlert("Could not connect to server", message: "", vc: self.myDelegate!.navigationController!)
                        }else {
                            
                             
                            var message : String? = ""
                            
                            if urlString.range(of: "open?") != nil {
                                responseDic = ["response" : responseData!]
                            }else {
                                responseDic = responseData as? Dictionary
                            }
                            
                            message = responseDic!["userMessage"] as? String

                            if message != nil {
                                CommonTask.task.showAlert(message as! String, message: "", vc: self.myDelegate!.navigationController!)
                            }else {
                                CommonTask.task.showAlert("Could not connect to server", message: "", vc: self.myDelegate!.navigationController!)
                            }
                        }

                    }
            })
            
            
        })
        
        self.sessionTask.resume()
    }
    //To show toast message
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(10.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
    

