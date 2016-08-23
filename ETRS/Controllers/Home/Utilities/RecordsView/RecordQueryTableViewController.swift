//
//  RecordQueryTableViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/22/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class RecordQueryTableViewController: PFQueryTableViewController {
    var activityIndicatorView: NVActivityIndicatorView?
    
    let currentUser = PFUser.currentUser()
    
    var timerecordsShown = [Bool]()
    
    var month:Int = NSDate.today().month
    
    var year:Int = NSDate.today().year
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "TimeRecording"
        self.textKey = "Employee"
        self.loadingViewEnabled = false
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableByMonth:",name:"reloadTableByMonth", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableByYear:",name:"reloadTableByYear", object: nil)
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = TimeRecording.query()
        query!.whereKey("Employee", equalTo: currentUser!.username!).whereKey("Month", equalTo: month).whereKey("Year", equalTo: year)
        query!.orderByDescending("Day")
        return query!
    }
    
    override func objectsWillLoad() {
        // Show activityIndicatior
        if self.activityIndicatorView == nil {
            let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallTrianglePath, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
            activityIndicatorView.center = self.view.center
            self.view.addSubview(activityIndicatorView)
            self.view.bringSubviewToFront(activityIndicatorView)
            self.activityIndicatorView = activityIndicatorView
            self.activityIndicatorView!.startAnimation()
        } else {
            self.activityIndicatorView!.hidden = false
            self.activityIndicatorView!.startAnimation()
        }
    }
    
    override func objectsDidLoad(error: NSError?) {
        self.activityIndicatorView!.stopAnimation()
        self.activityIndicatorView!.hidden = true
        
        let timerecordsShown = [Bool](count: objects!.count, repeatedValue: false)
        self.timerecordsShown = timerecordsShown

        //self.prepareVisibleCellsForAnimation()
        //self.animateVisibleCells()
    }
    
    func reloadTableByMonth(notification: NSNotification){
        //load data here
        //print("Reload")
        let userInfo:Dictionary<String,Int!> = notification.userInfo as! Dictionary<String,Int!>
        let month = userInfo["month"]
        self.month = month!
        self.clear()
        self.loadObjects()
    }
    
    func reloadTableByYear(notification: NSNotification){
        //load data here
        //print("Reload")
        let userInfo:Dictionary<String,Int!> = notification.userInfo as! Dictionary<String,Int!>
        let year = userInfo["year"]
        self.year = year!
        self.clear()
        self.loadObjects()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("RecordQueryCell") as! RecordQueryViewCell!
        if cell == nil {
            cell = RecordQueryViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "RecordQueryCell")
        }
        
        //Config cell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.MKColor.Blue
        
        // Extract values from the PFObject to display in the table cell
        let objectTR = object as! TimeRecording
        cell.checkInTimeLB.text = "---:---"
        cell.checkOutTimeLB.text = "---:---"
        if objectTR.StartTimeRecord != nil {
            cell.checkInTimeLB.text = objectTR.StartTimeRecord
        }
        
        if objectTR.EndTimeRecord != nil {
            cell.checkOutTimeLB.text = objectTR.EndTimeRecord
        }
        /*
        if objectTR.Day != nil {
            cell.dateLB.text = objectTR.Day
        }*/
        cell.dateLB.text = String(objectTR.Day)
        /*
        if objectTR.Day != nil &&  objectTR.Month != nil && objectTR.Year != nil {
            let date = "\(objectTR.Day!)/\(objectTR.Month!)/\(objectTR.Year!)"
            cell.dayWeekLB.text = getWeekday(date)
        }*/
        let date = "\(objectTR.Day)/\(objectTR.Month)/\(objectTR.Year)"
        cell.dayWeekLB.text = getWeekday(date)
        
        /*
        if objectTR.Date != nil {
            cell.dayWeekLB.text = self.getWeekday(objectTR.Date!)
            let componentArray = objectTR.Date!.characters.split {$0 == "-"}.map { String($0) }
            cell.dateLB.text = componentArray[0]
        }*/
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        if timerecordsShown[indexPath.row] == false {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            cell.layer.transform = rotationTransform
            UIView.animateWithDuration(1.0) { () -> Void in
                cell.layer.transform = CATransform3DIdentity
            }
            timerecordsShown[indexPath.row] = true
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        let headerTitle = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        var monthByString = ""
        switch self.month {
        case 1:
            monthByString = checkLanguage("january")
        case 2:
            monthByString = checkLanguage("february")
        case 3:
            monthByString = checkLanguage("march")
        case 4:
            monthByString = checkLanguage("april")
        case 5:
            monthByString = checkLanguage("may")
        case 6:
            monthByString = checkLanguage("june")
        case 7:
            monthByString = checkLanguage("july")
        case 8:
            monthByString = checkLanguage("august")
        case 9:
            monthByString = checkLanguage("september")
        case 10:
            monthByString = checkLanguage("october")
        case 11:
            monthByString = checkLanguage("november")
        case 12:
            monthByString = checkLanguage("december")
        default:
            monthByString = ""
        }
        headerTitle.text = monthByString + " - " + String(year)
        headerTitle.textAlignment = .Center
        headerTitle.font = UIFont(name: "Helvetica Neue-Light", size: 30)
        headerTitle.textColor = UIColor.whiteColor()
        headerTitle.backgroundColor = UIColor.clearColor()
        headerView.addSubview(headerTitle)
        return headerView
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
    
    func getWeekday(date: String) -> String {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        var weekdayByString = ""
        if let formatDate = formatter.dateFromString(date) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: formatDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                weekdayByString = checkLanguage("sunday")
            case 2:
                weekdayByString = checkLanguage("monday")
            case 3:
                weekdayByString = checkLanguage("tuesday")
            case 4:
                weekdayByString = checkLanguage("wednesday")
            case 5:
                weekdayByString = checkLanguage("thursday")
            case 6:
                weekdayByString = checkLanguage("friday")
            case 7:
                weekdayByString = checkLanguage("saturday")
            default:
                return weekdayByString
            }
        }
        return weekdayByString
    }
    
    func prepareVisibleCellsForAnimation() {
        for var i=0; i < self.objects?.count; i++ {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! RecordQueryViewCell
            cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds))
            cell.alpha = 0
        }
    }
    
    func animateVisibleCells() {
        for var i=0; i < self.objects?.count; i++ {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! RecordQueryViewCell
            cell.alpha = 1
            UIView.animateWithDuration(0.25, delay: Double(i)*0.2, options: .CurveEaseOut, animations: { () -> Void in
                cell.frame = CGRectMake(0, cell.frame.origin.y, CGRectGetHeight(cell.bounds), CGRectGetHeight(cell.bounds))
            }, completion: nil)
        }
    }
}