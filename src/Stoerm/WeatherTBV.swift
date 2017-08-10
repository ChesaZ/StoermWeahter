//
//  weatherTBV.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 08/08/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit

class weatherTBV: UITableViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
