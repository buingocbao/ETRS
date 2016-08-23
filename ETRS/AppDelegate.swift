//
//  AppDelegate.swift
//  ETRS
//
//  Created by BBaoBao on 9/9/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var beaconManager:ESTBeaconManager!
    var beaconRegion:CLBeaconRegion!
    
    var beacon:Beacon!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Hide status bar all views
        application.statusBarHidden = true
        // Mark: Parse
        Parse.enableLocalDatastore()
        User.registerSubclass()
        Beacon.registerSubclass()
        TimeRecording.registerSubclass()
        CompanyOfficialHour.registerSubclass()
        Parse.setApplicationId("4OnWb9XZC1jm5FpuH8J6JTaH2Gq1obJvudbE4aba", clientKey:"SbxRQuDpfoT0pqWzcYHOuLV5uBnlpYIDvUQMTQg2")
        //PFUser.logOut()
        // Mark: Estimote
        ESTConfig.setupAppID("etrs", andAppToken: "7330407b28a2d07984cf228f352cf048")
        // Request authorizartion from user
        beaconManager = ESTBeaconManager()
        if ((beaconManager?.respondsToSelector("requestAlwaysAuthorization")) != nil) {
            beaconManager?.requestAlwaysAuthorization()
        }
        beaconManager?.delegate = self
        if let currentUser = User.currentUser() {
            self.beacon = decryptBeaconInfo(currentUser)
            
            beaconRegion = CLBeaconRegion(
                proximityUUID: NSUUID(UUIDString: beacon.UUID)!,
                major: CLBeaconMajorValue(Int(beacon.Major)!), minor: CLBeaconMajorValue(Int(beacon.Minor)!), identifier: "monitored region")
            self.beaconManager.startMonitoringForRegion(beaconRegion)
            self.beaconManager.startRangingBeaconsInRegion(beaconRegion)
        }
        
        // MAKR: Check permission for notification
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound],
                    categories: nil
                )
            )
        }
        
        // MARK: Check language
        // Check language of application
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.stringForKey("Language"){
            //Exist setting for language
        } else {
            //First time run app
            defaults.setObject("en", forKey: "Language")
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Additional Methods
    func checkLanguage(key: String) -> String {
        //Get language setting
        let defaults = NSUserDefaults.standardUserDefaults()
        var language = ""
        if let lg = defaults.stringForKey("Language"){
            language = lg
        }
        language = "vi"
        let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        let string = bundle?.localizedStringForKey(key, value: nil, table: nil)
        return string!
    }
    
    func decryptBeaconInfo(currentUser: User) -> Beacon {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let beaconInfo = currentUser.Beacon.aesDecrypt(key, iv: iv)
        print(beaconInfo)
        var componentArray = beaconInfo.characters.split {$0 == "_"}.map { String($0) }
        let beacon = Beacon()
        beacon.UUID = componentArray[0]
        beacon.Major = componentArray[1]
        beacon.Minor = componentArray[2]
        return beacon
    }
    
    func makeIntegrityData(data: String) -> String {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let encryptedData = data.aesEncrypt(key, iv: iv)
        //let decryptedData = encryptedData.aesDecrypt(key, iv: iv)
        //print(decryptedData)
        return encryptedData
    }
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
}

extension AppDelegate: ESTBeaconManagerDelegate {
    
    func beaconManager(manager: AnyObject!, didStartMonitoringForRegion region: CLBeaconRegion!) {
        beaconManager.requestStateForRegion(region)
    }
    
    func beaconManager(manager: AnyObject!, didDetermineState state: CLRegionState, forRegion region: CLBeaconRegion!) {
        if state == CLRegionState.Inside {
            beaconManager.startRangingBeaconsInRegion(beaconRegion)
        } else {
            //beaconManager.stopRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func beaconManager(manager: AnyObject!, didEnterRegion region: CLBeaconRegion!) {
        print("Enter Region")
        if connectedToNetwork() {
            //User's connected to network by 3G/4G or Wifi
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                var language = ""
                if let lg = defaults.stringForKey("Language"){
                    language = lg
                }
                let queryCOH = CompanyOfficialHour.query()
                queryCOH?.whereKey("Language", equalTo: language)
                queryCOH?.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                    if error == nil {
                        //Push welcome sentence
                        print(object)
                        let coh = object as! CompanyOfficialHour
                        self.sendLocalNotificationWithMessage(coh.WelcomeSentence, forStatus: "enter_welcome")
                        self.checkRecordTime()
                    } else {
                        //Failed because something
                        print(error)
                    }
                })
            })
        } else {
            //User isn't connected to network
            self.sendLocalNotificationWithMessage(checkLanguage("enter_no_network"), forStatus: "EnterNoNetwork")
        }
    }
    
    func beaconManager(manager: AnyObject!, didExitRegion region: CLBeaconRegion!) {
        print("Exit Region")
        //sendLocalNotificationWithMessage("Exit Region", forStatus: "")
    }
    
    func sendLocalNotificationWithMessage(message: String, forStatus: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.stringForKey(forStatus) {
            //User's already received the message. Do nothing here!
        } else {
            //User's not received the message.
            let notification:UILocalNotification = UILocalNotification()
            notification.alertBody = message
            notification.soundName = "NotificationSound.m4a"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            let day = String(NSDate.today().day)
            let month = String(NSDate.today().month)
            let year = String(NSDate.today().year)
            
            let daymonthyear = "\(day)-\(month)-\(year)"
    
            defaults.setObject(daymonthyear, forKey: forStatus)
        }
        
    }
    
    func checkRecordTime() {
        if let currentUser = User.currentUser() {
            let day = NSDate.today().day
            let month = NSDate.today().month
            let year = NSDate.today().year
            
            let daymonthyear = "\(day)-\(month)-\(year)"
            
            let queryTR = TimeRecording.query()// PFQuery(className: "TimeRecording")
            queryTR!.whereKey("Employee", equalTo: currentUser.username!)
            queryTR!.whereKey("Day", equalTo: day)
            queryTR!.whereKey("Month", equalTo: month)
            queryTR!.whereKey("Year", equalTo: year)
            queryTR!.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                if error == nil {
                    //Have record for today
                    //TODO: Can check some error here
                    //1: Don't have StartTimeRecord but have Date
                    //2: Don't have StartTimeRecord but have EndTimeRecord
                    //3: Have StartTimeRecord but dont have EndTimeRecord <-- normal status.
                    //self.checkRecordStatus(object as! TimeRecording)
                } else {
                    //Don't have record for today
                    self.checkIn(currentUser, daymonthyear: daymonthyear)
                }
            })
        }
    }
    
    func checkRecordStatus(objectTR: TimeRecording) {
        if objectTR.EndTimeRecord != nil {
            
        }
    }
    
    func checkIn(currentUser:User, daymonthyear: String) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Day, .Month, .Year], fromDate: date)
        let hour = String(components.hour)
        let minute = String(components.minute)
        
        let hourminute = "\(hour):\(minute)"
        
        let timeRecord = TimeRecording()
        timeRecord.Employee = currentUser.username!
        //timeRecord.Date = daymonthyear
        timeRecord.StartTimeRecord = hourminute
        timeRecord.Group = currentUser.Group
        timeRecord.Day = NSDate.today().day
        timeRecord.Month = NSDate.today().month
        timeRecord.Year = NSDate.today().year
        //Set ACL for object Time Record
        let timeRecordACL = PFACL()
        //Read ACL
        timeRecordACL.setPublicReadAccess(false)
        timeRecordACL.setReadAccess(true, forUser: currentUser)
        timeRecordACL.setReadAccess(true, forRoleWithName: "Admin")
        timeRecordACL.setReadAccess(true, forRoleWithName: "Manager")
        //Write ACL
        timeRecordACL.setPublicWriteAccess(false)
        timeRecordACL.setWriteAccess(true, forUser: currentUser)
        timeRecordACL.setWriteAccess(true, forRoleWithName: "Admin")
        timeRecordACL.setWriteAccess(false, forRoleWithName: "Manager")
        timeRecord.ACL = timeRecordACL
        let integrityData = "\(self.beacon.UUID)_\(self.beacon.Major)_\(self.beacon.Minor)_\(currentUser.username)_\(currentUser.Group)_\(daymonthyear)_\(hourminute)_In"
        timeRecord.Integrity = makeIntegrityData(integrityData)
        timeRecord.saveEventually { (succeeded, error) -> Void in
            if succeeded {
                print("Saved successfully")
                let successSentence = self.checkLanguage("enter_checkin_successfully") + " \(currentUser.FirstName) \(currentUser.LastName)"
                self.sendLocalNotificationWithMessage(successSentence, forStatus: "EnterCheckin")
            } else {
                print(error)
            }
        }
    }
}

