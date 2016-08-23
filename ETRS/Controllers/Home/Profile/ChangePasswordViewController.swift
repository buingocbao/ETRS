//
//  ChangePasswordViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/28/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    var passwordTF: MKTextField!
    var confirmTF: MKTextField!
    var activityIndicatorView: NVActivityIndicatorView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = checkLanguage("new_password")
        self.contentSizeInPopup = CGSizeMake(300, 100)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.MKColor.Blue
        configTextFields()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: checkLanguage("save"), style: .Plain, target: self, action: Selector("saveButtonTapped"))
    }
    
    // Create Activity Indicator
    func createActivityIndicator() {
        let activityTypes: NVActivityIndicatorType = .BallTrianglePath
        let frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
            type: activityTypes)
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        self.activityIndicatorView?.hidden = true
    }

    func configTextFields() {
        passwordTF = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        passwordTF.layer.borderColor = UIColor.clearColor().CGColor
        passwordTF.floatingPlaceholderEnabled = true
        passwordTF.placeholder = checkLanguage("password")
        passwordTF.tintColor = UIColor.whiteColor()
        passwordTF.textColor = UIColor.whiteColor()
        passwordTF.rippleLocation = .Right
        passwordTF.cornerRadius = 0
        passwordTF.bottomBorderEnabled = true
        passwordTF.borderStyle = UITextBorderStyle.None
        passwordTF.minimumFontSize = 17
        passwordTF.font = UIFont(name: "HelveticaNeue", size: 20)
        passwordTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        passwordTF.secureTextEntry = true
        passwordTF.delegate = self
        self.view.addSubview(passwordTF)

        confirmTF = MKTextField(frame: CGRect(x: 0, y: passwordTF.frame.height+10, width: self.view.frame.width, height: 40))
        confirmTF.layer.borderColor = UIColor.clearColor().CGColor
        confirmTF.floatingPlaceholderEnabled = true
        confirmTF.placeholder = checkLanguage("confirm_password")
        confirmTF.tintColor = UIColor.whiteColor()
        confirmTF.textColor = UIColor.whiteColor()
        confirmTF.rippleLocation = .Right
        confirmTF.cornerRadius = 0
        confirmTF.bottomBorderEnabled = true
        confirmTF.borderStyle = UITextBorderStyle.None
        confirmTF.minimumFontSize = 17
        confirmTF.font = UIFont(name: "HelveticaNeue", size: 20)
        confirmTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        confirmTF.secureTextEntry = true
        confirmTF.delegate = self
        self.view.addSubview(confirmTF)
    }
    
    func saveButtonTapped() {
        if passwordTF.text != "" && confirmTF.text != "" {
            if passwordTF.text != confirmTF.text {
                passwordTF.textColor = UIColor.MKColor.Red
                confirmTF.textColor = UIColor.MKColor.Red
            } else if passwordTF.text == confirmTF.text {
                print("Do save function")
                self.doSaveFunction()
                
            } else {
                passwordTF.textColor = UIColor.whiteColor()
                confirmTF.textColor = UIColor.whiteColor()
            }
        }
    }
    
    func doSaveFunction() {
        self.activityIndicatorView?.hidden = false
        self.activityIndicatorView?.startAnimation()
        let currentUser = PFUser.currentUser()
        currentUser?.password = passwordTF.text
        currentUser?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                self.activityIndicatorView?.hidden = true
                self.activityIndicatorView?.stopAnimation()
                self.passwordTF.text = ""
                self.confirmTF.text = ""
                let alert = UIAlertController(title: self.checkLanguage("success"), message: self.checkLanguage("changed_pass_success"), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: self.checkLanguage("ok"), style: .Default, handler: { (alert) -> Void in
                    PFUser.logOut()
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC : LoginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                    
                    self.presentViewController(loginVC, animated: true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: self.checkLanguage("error"), message: self.checkLanguage("error_check_in") + "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: self.checkLanguage("ok"), style: .Default, handler: { (alert) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Other methods
    func checkLanguage(key: String) -> String {
        //Get language setting
        let defaults = NSUserDefaults.standardUserDefaults()
        var language = "en"
        if let lg = defaults.stringForKey("Language"){
            language = lg
        }
        let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        let string = bundle?.localizedStringForKey(key, value: nil, table: nil)
        return string!
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === passwordTF {
            confirmTF.becomeFirstResponder()
        } else if textField === confirmTF {
            confirmTF.resignFirstResponder()
            doSaveFunction()
        }
        return true
    }

}
