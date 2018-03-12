//
//  OrdenesTableViewCell.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 04-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class OrdenesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOperacion: UILabel!
    @IBOutlet weak var lblMonto: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblFilled: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalEjecutado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
