//
//  RecordQueryViewCell.swift
//  ETRS
//
//  Created by BBaoBao on 9/22/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class RecordQueryViewCell: PFTableViewCell {
    
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var dayWeekLB: UILabel!
    @IBOutlet weak var checkInTimeLB: UILabel!
    @IBOutlet weak var checkOutTimeLB: UILabel!
    @IBOutlet weak var checkInImg: UIImageView!
    @IBOutlet weak var checkOutImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLB.backgroundColor = UIColor.whiteColor()
        dateLB.textColor = UIColor.MKColor.Blue
        dateLB.layer.masksToBounds = true
        dateLB.layer.cornerRadius = 40
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
