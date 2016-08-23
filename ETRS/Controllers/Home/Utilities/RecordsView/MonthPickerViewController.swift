//
//  MonthPickerViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/23/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol MonthPickerViewControllerDelegate
{
    func sendMonthValue(var value : Int)
}

class MonthPickerViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    @IBOutlet weak var descripLB: UILabel!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    var backButton: MKButton = MKButton()
    var delegate: MonthPickerViewControllerDelegate?
    
    let currentMonth = NSDate.today().month
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLabels()
        configBackButton()
        configCollectionView()
    }
    
    func configLabels() {
        headerLB.text = checkLanguage("month_header_label")
        descripLB.text = checkLanguage("month_description_label")
    }
    
    func configCollectionView() {
        monthCollectionView.backgroundColor = UIColor.clearColor()
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
    }
    
    func configBackButton() {
        // Back Button
        backButton.frame = CGRect(x: 20, y: self.view.bounds.height-60, width: 40, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Red
        backButton.cornerRadius = 20.0
        backButton.backgroundLayerCornerRadius = 20.0
        backButton.maskEnabled = false
        backButton.rippleLocation = .Center
        backButton.ripplePercent = 1.75
        backButton.setImage(UIImage(named: "DownArrow"), forState: UIControlState.Normal)
        //backButton.setTitle("X", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
    }

    func backButtonClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
}

extension MonthPickerViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MonthCell", forIndexPath: indexPath) as! MonthPickerCollectionViewCell
        
        cell.monthLB.text = String(indexPath.row+1)
        cell.monthLB.textColor = UIColor.whiteColor()
        cell.monthLB.layer.masksToBounds = true
        cell.monthLB.layer.cornerRadius = 10
        cell.monthLB.backgroundColor = UIColor.MKColor.Blue
//        if indexPath.row+1 <= self.currentMonth {
//            cell.monthLB.backgroundColor = UIColor.MKColor.Blue
//        } else {
//            cell.monthLB.backgroundColor = UIColor.MKColor.Grey
//            cell.userInteractionEnabled = false
//        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width/3-7, height: self.view.bounds.width/3-7)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        for i in 0...11 {
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! MonthPickerCollectionViewCell
            if i == indexPath.row {
                cell.monthLB.backgroundColor = UIColor.MKColor.Red
                collectionView.deselectItemAtIndexPath(indexPath, animated: false)
                self.delegate?.sendMonthValue(i+1)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                cell.monthLB.backgroundColor = UIColor.MKColor.Blue
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}