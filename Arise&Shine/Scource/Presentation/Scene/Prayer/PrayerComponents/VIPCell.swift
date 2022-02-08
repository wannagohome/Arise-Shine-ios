//
//  VIPCell.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/29.
//

import UIKit

class VIPCell: UITableViewCell {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var vipDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
