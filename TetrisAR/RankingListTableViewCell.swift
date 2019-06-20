//
//  RankingListTableViewCell.swift
//  ARTetris
//
//  Created by 马宝森 on 2019/6/17.
//  Copyright © 2019 Exyte. All rights reserved.
//

import UIKit

class RankingListTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var rankIndex: UILabel!
    @IBOutlet weak var rankName: UILabel!
    @IBOutlet weak var rankScore: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
