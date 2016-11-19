//
//  ViewController.swift
//  Swear Jar Pro
//
//  Created by Rahul Surti on 11/19/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchIDButton(_ sender: UIButton) {
        authenticate()
    }
    
    func authenticate() {
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        var error:NSError?
        
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertWithTitle(title: "Insufficient Hardware", message: "Touch ID not available on device")
            return
            
        }
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Only awesome people are allowed",
            reply: { [unowned self] (success, error) -> Void in
                if success {
                    print("Success")
                    Alamofire.request("https://httpbin.org/get").responseJSON(completionHandler: { (response: DataResponse<Any>) in
                        print(response.request)  // original URL request
                        print(response.response) // HTTP URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                    })
                } else {
                    // Check if there is an error
                    if let e = error {
                        let message = self.errorMessageForLAErrorCode(errorCode: e._code)
                        print(message)
                        DispatchQueue.main.async {
                            //update UI
                        }
                    }
                }
        })
    }
    
    
    
    
    /**
     This method presents an UIAlertViewController to the user.
     
     - parameter title:  The title for the UIAlertViewController.
     - parameter message:The message for the UIAlertViewController.
     
     */
    func showAlertWithTitle( title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    
    /**
     This method will return an error message string for the provided error code.
     The method check the error code against all cases described in the `LAError` enum.
     If the error code can't be found, a default message is returned.
     
     - parameter errorCode: the error code
     - returns: the error message
     */
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
//            DispatchQueue.main.async {
//                self.touchIDButtonOutlet.isHidden = true
//                self.usernameTextField.isHidden = false
//                self.passwordTextField.isHidden = false
//            }
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            showAlertWithTitle(title: "Passcode not set", message: "Passcode must be set to enable Touch ID")
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
//            showAlertWithTitle(title: "Too many attempts", message: "Please log in with username and password")
//            DispatchQueue.main.async {
//                self.touchIDButtonOutlet.isHidden = true
//                self.usernameTextField.isHidden = false
//                self.passwordTextField.isHidden = false
//            }
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        return message
    }
}

