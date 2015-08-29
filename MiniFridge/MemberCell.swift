//
//  MyClubCell.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/29/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}