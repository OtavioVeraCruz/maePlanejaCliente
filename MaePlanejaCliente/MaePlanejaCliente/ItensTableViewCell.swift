//
//  ItensTableViewCell.swift
//  MaePlanejaCliente
//
//  Created by Jailson José da Silva junior  on 20/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class ItensTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagemTableViewCell: UIImageView!
    @IBOutlet weak var titleTableViewCell: UILabel!
    @IBOutlet weak var priceTableViewCell: UILabel!
    @IBOutlet weak var recomendationTableViewCell: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
