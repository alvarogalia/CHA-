//
//  HistorialTableViewCell.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 12-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class HistorialTableViewCell: UITableViewCell {

    @IBOutlet weak var lblChauchas: UILabel!
    @IBOutlet weak var lblLimit: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
