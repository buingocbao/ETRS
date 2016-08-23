//
//  ProfileTableViewCell.swift
//  ETRS
//
//  Created by BBaoBao on 9/28/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var detailLB: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
