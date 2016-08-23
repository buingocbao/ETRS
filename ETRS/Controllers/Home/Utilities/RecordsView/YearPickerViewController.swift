//
//  YearPickerViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/27/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol YearPickerViewControllerDelegate
{
    func sendYearValue(var value : Int)
}

class YearPickerViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    @IBOutlet weak var descripLB: UILabel!
    @IBOutlet weak var yearCollectionView: UICollectionView!
    
    var backButton: MKButton = MKButton()
    var delegate: YearPickerViewControllerDelegate?
    
    var years = [NSDate.today().year-5,NSDate.today().year-4,NSDate.today().year-3,NSDate.today().year-2,NSDate.today().year-1,NSDate.today().year,NSDate.today().year+1,NSDate.today().year+2,NSDate.today().year+3,NSDate.today().year+4]

    override func viewDidLoad() {
        super.viewDidLoad()
        configLabels()
        configBackButton()
        configCollectionView()
    }

    func configLabels() {
        headerLB.text = checkLanguage("year_header_label")
        descripLB.text = checkLanguage("year_description_label")
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
    
    func configCollectionView() {
        yearCollectionView.backgroundColor = UIColor.clearColor()
        yearCollectionView.delegate = self
        yearCollectionView.dataSource = self
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

extension YearPickerViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return years.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YearCell", forIndexPath: indexPath) as! YearPickerCollectionViewCell
        
        cell.yearLabel.text = String(years[indexPath.row])
        cell.yearLabel.textColor = UIColor.whiteColor()
        cell.yearLabel.layer.masksToBounds = true
        cell.yearLabel.layer.cornerRadius = 10
        
        if indexPath.row <= 5 {
            cell.yearLabel.backgroundColor = UIColor.MKColor.Blue
        } else {
            cell.yearLabel.backgroundColor = UIColor.MKColor.Grey
            cell.userInteractionEnabled = false
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width-10, height: 100)
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
        /*
        for i in 0...years.count-1 {
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! YearPickerCollectionViewCell
            if i == indexPath.row {
                print(i)
                //cell.yearLabel.backgroundColor = UIColor.MKColor.Red
                //collectionView.deselectItemAtIndexPath(indexPath, animated: false)
                //self.delegate?.sendYearValue(years[indexPath.row])
                //self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                //cell.yearLabel.backgroundColor = UIColor.MKColor.Blue
            }
        }*/
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        self.delegate?.sendYearValue(years[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
