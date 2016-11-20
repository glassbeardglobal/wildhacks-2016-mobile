//
//  LoginViewController.swift
//  Swear Jar Pro
//
//  Created by Rahul Surti on 11/19/16.
//  Copyright © 2016 rahulsurti. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    var loginState: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBOutlet weak var continueButtonOutlet: UIButton!
    
    @IBAction func continueButton(_ sender: UIButton) {
        if(emailAddressTextField.text! == "" || passwordTextField.text! == "") {
            return
        }
        if(loginState) {
            dismissKeyboard()
//            let parameters: Parameters = [
//                "email": emailAddressTextField.text ?? "",
//                "password": passwordTextField.text ?? ""
//            ]
            guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
                print("could not get token")
                return
            }

            print("token: \(token)")
            let tokenParams = [
                "email" : self.emailAddressTextField.text ?? "",
                "deviceToken" : token
            ]
            
            let register = Alamofire.request("https://sjback.herokuapp.com/api/push/registertoken", method: .post, parameters: tokenParams, encoding: JSONEncoding.default)
            register.responseJSON(completionHandler: {(registerResponse: DataResponse<Any>) in
                print(registerResponse.request)  // original URL request
                print(registerResponse.response) // HTTP URL response
                print(registerResponse.data)     // server data
                print(registerResponse.result.value)   // result of response serialization
            })

            
//            Alamofire.request("https://sjback.herokuapp.com/api/users/authenticate", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
//                    print(response.request)  // original URL request
//                    print(response.response) // HTTP URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    
//                    //to get status code
//                    if let status = response.response?.statusCode {
//                        guard 200..<300 ~= status else {
//                            print("error with response status: \(status)")
//                            return
//                        }
//                        
//                        guard let JSON = response.result.value as? NSDictionary else {
//                            print("could not parse JSON")
//                            return
//                        }
//                        
//                        guard let user = JSON.object(forKey: "user") as? NSDictionary else {
//                            print("could not get user from JSON")
//                            return
//                        }
//                        
//                        guard let id = user.object(forKey: "_id") as? String else {
//                            print("could not get id from user dict")
//                            return
//                        }
//                        print(id)
//                        UserDefaults.standard.set(id, forKey: "userID")
//                        
//                    }
//                })
            
            
        } else { //sign up state
            dismissKeyboard()
            let parameters: Parameters = [
                "name": nameTextField.text ?? "",
                "email": emailAddressTextField.text ?? "",
                "password": passwordTextField.text ?? ""
            ]
            let post = Alamofire.request("https://sjback.herokuapp.com/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            post.responseJSON(completionHandler: { (response: DataResponse<Any>) in
//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                guard let status = response.response?.statusCode else {
                    print("could not get status code")
                    return
                }
                
                guard 200..<300 ~= status else {
                    print("error with response status: \(status)")
                    return
                }
                
                guard let JSON = response.result.value as? NSDictionary else {
                    print("could not parse JSON")
                    return
                }
                
                guard let user = JSON.object(forKey: "user") as? NSDictionary else {
                    print("could not get user from JSON")
                    return
                }
                
                guard let id = user.object(forKey: "_id") as? String else {
                    print("could not get id from user dict")
                    UserDefaults.standard.removeObject(forKey: "userID")
                    return
                }
                print(id)
//                print(response.response?)
                UserDefaults.standard.set(id, forKey: "userID")
//                guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
//                    print("could not get token")
//                    return
//                }
//                print("token: \(token)")
//                let tokenParams = [
//                    "email" : self.emailAddressTextField.text ?? "",
//                    "deviceToken" : token
//                ]

//                let register = Alamofire.request("https://sjback.herokuapp.com/api/users/registertoken", method: .post, parameters: tokenParams, encoding: JSONEncoding.default)
//                register.responseJSON(completionHandler: {(registerResponse: DataResponse<Any>) in
//                    print(registerResponse.request)  // original URL request
//                    print(registerResponse.response) // HTTP URL response
//                    print(registerResponse.data)     // server data
//                    print(registerResponse.result.value)   // result of response serialization
//                })

                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "logInSuccessfulSegue", sender: self)
                }

//                let get = Alamofire.request("https://sjback.herokuapp.com/api/users/\(id)")
//                get.responseJSON(completionHandler: { (response1: DataResponse<Any>) in
//                    print(response1.result)   // result of response serialization
//                    guard let status1 = response1.response?.statusCode else {
//                        print("could not get status code")
//                        return
//                    }
//                    
//                    guard 200..<300 ~= status1 else {
//                        print("error with response status: \(status1)")
//                        return
//                    }
//                    
//                    guard let JSON1 = response1.result.value as? NSDictionary else {
//                        print("could not parse JSON")
//                        return
//                    }
//                    
//                    guard let user1 = JSON1.object(forKey: "user") as? NSDictionary else {
//                        print("could not get user from JSON")
//                        return
//                    }
//                    
//                    guard let id1 = user1.object(forKey: "_id") as? String else {
//                        print("could not get id from user dict")
//                        UserDefaults.standard.removeObject(forKey: "userID")
//                        return
//                    }
//                    
//                    if(id == id1) {
//                        print("OK")
//                    }
//                })
            })
        }
    }
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//        
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y != 0 {
//                self.view.frame.origin.y = 0
//            }
//        }
//    }
    
    
    func setUp(){
        if(loginState) {
            mainTitleLabel.text = "Enter username and password"
            subTitleLabel.text = "to continue"
            continueButtonOutlet.setTitle("Log in", for: .normal)
            nameTextField.isHidden = true
        } else {
            mainTitleLabel.text = "Let's get started"
            subTitleLabel.text = "Enter the following"
            continueButtonOutlet.setTitle("Create Account", for: .normal)
        }
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.emailAddressTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName:UIColor.darkGray])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.darkGray])
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName:UIColor.darkGray])
        
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
