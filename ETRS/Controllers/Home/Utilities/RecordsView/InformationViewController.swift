//
//  InformationViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/22/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHeaderLB()
        createBackgroundView()
    }
    
    func configHeaderLB() {
        headerLB.text = checkLanguage("records_info")
    }
    
    func createBackgroundView(){
        self.view.backgroundColor = UIColor.MKColor.Blue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "monthPickSegue" {
            (segue.destinationViewController as! MonthPickerViewController).delegate = self
        }
        if segue.identifier == "yearPickSegue" {
            (segue.destinationViewController as! YearPickerViewController).delegate = self
        }
    }
}

extension InformationViewController: YALTabBarInteracting {
    func extraLeftItemDidPress() {
        print("Month press!")
        self.performSegueWithIdentifier("monthPickSegue", sender: nil)
    }
    
    func extraRightItemDidPress() {
        print("Year press!")
        self.performSegueWithIdentifier("yearPickSegue", sender: nil)
    }
}

extension InformationViewController: MonthPickerViewControllerDelegate {
    func sendMonthValue(value: Int) {
        //print(value)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableByMonth", object: nil, userInfo: ["month":value])
    }
}

extension InformationViewController: YearPickerViewControllerDelegate {
    func sendYearValue(value: Int) {
        //print(value)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTableByYear", object: nil, userInfo: ["year":value])

    }
}