//
//  ImageTableViewCell.swift
//  Swirl
//
//  Created by shani herskowitz on 4/15/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var ImageLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var RatingsControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
