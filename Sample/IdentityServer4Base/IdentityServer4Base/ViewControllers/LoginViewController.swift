//
//  LoginViewController.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 7/31/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {

    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    private var authReqManager: OAuthApiRequestManager!
    
    var hud: MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        authReqManager = appDelegate.authReqManager
        
        if(authReqManager.credentialsFoundOnStartup){
            txtUsername.text = authReqManager._credentialSet.username
            txtPassword.text = authReqManager._credentialSet.password
        }
        
        // Do any additional setup after loading the view.
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

    @IBAction func logMeInClicked(_ sender: UIButton) {

        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Logging You In"
        spinnerActivity.detailsLabel.text = "Hang Tight!"
        spinnerActivity.isUserInteractionEnabled = false
        
        authReqManager.authorize(username: txtUsername.text!, password: txtPassword.text!, saveForFuture: true,
                                 completionBlock: { (authorizeResult) -> Void in
                                    switch authorizeResult{
                                        case .success(let cred):
                                           self.stopActivityIndicator()
                                            let alertController = UIAlertController(title: "Authentication Sucessful", message:
                                                "Welcome \(self.txtUsername.text!)! \n \(cred.authToken)", preferredStyle: UIAlertControllerStyle.alert)
                                            
                                            //alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                                            
                                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (uiAlertAction) in
                                                 self.performSegue(withIdentifier: "MainController", sender: self)
                                            }))
                                            //alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))

                                            //self.present(alertController, animated: true, completion: {self.performSegue(withIdentifier: "MainController", sender: self)})
                                            self.present(alertController, animated: true)
                                        
                                        
                                        
                                    case .failure(let oAuthApiAuthorizeError):
                                            self.stopActivityIndicator()
                                            if case .InvalidUsernamePassword(let str) = oAuthApiAuthorizeError{
                                                //https://stackoverflow.com/questions/44061147/how-to-do-an-if-else-comparison-on-enums-with-arguments
                                                self.stopActivityIndicator()
                                                let alertController = UIAlertController(title: "Authentication Failed", message:
                                                    "str", preferredStyle: UIAlertControllerStyle.alert)
                                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                                                
                                                self.present(alertController, animated: true, completion: nil)
                                                
                                        }
                                    }
            
                                })
    }//end logMeInClicked
    
    
    
    @IBAction func signUpClicked(_ sender: UIButton) {
    }
    
    func stopActivityIndicator()
    {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
}
