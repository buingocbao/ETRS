//
//  CompanyOfficialHour.swift
//  ETRS
//
//  Created by BBaoBao on 9/20/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class CompanyOfficialHour: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "CompanyOfficalHour"
    }
    
    // MARK: - Parse Core Properties
    @NSManaged var Start: String
    @NSManaged var End: String
    @NSManaged var WelcomeSentence: String
    @NSManaged var GoodbyeSentence: String
}
