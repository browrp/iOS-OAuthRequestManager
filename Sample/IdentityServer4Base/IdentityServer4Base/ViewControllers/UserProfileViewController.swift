//
//  UserProfileViewController.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 11/2/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    private var userService: UserService!
    
    private var responseText: String!
    
    @IBOutlet weak var txtResponseData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         userService = UserService.shared()
        
        refreshDataFromUserService()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnRefreshDataClick(_ sender: UIButton) {
        refreshDataFromUserService()
        
    }
    
    
    func refreshDataFromUserService()
    {
       
        
        userService.getProfile { (result) in
            switch result{
            case .success(let val):
                self.responseText = val;
                
                DispatchQueue.main.async {
                    self.txtResponseData.text = self.responseText
                }
                
            case .failure(let err):
                print(err);
            }
        }
    }
    
    @IBAction func btnMessItUp(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var  authReqManager: OAuthApiRequestManager = appDelegate.authReqManager
        
        authReqManager._credentialSet.authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
