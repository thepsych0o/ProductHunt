//
//  Cell.swift
//  ProductHunt
//
//  Created by Эдгар on 27.06.2017.
//  Copyright © 2017 D-WIN. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    //1
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
