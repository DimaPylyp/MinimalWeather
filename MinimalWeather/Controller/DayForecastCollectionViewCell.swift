//
//  DayForecastCollectionViewCell.swift
//  MinimalWeather
//
//  Created by DiMa on 16/03/2020.
//  Copyright © 2020 DiMa. All rights reserved.
//

import UIKit

class DayForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherPicture: UIImageView!
    
    override func awakeFromNib() {
        weatherPicture.image = weatherPicture.image?.withRenderingMode(.alwaysTemplate)
    }
}
