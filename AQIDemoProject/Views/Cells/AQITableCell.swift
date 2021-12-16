//
//  AQITableCell.swift
//  AQIDemoProject
//
//  Created by Mayur on 07/12/21.
//

import UIKit

class AQITableCell: UITableViewCell {

    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblAQI: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib() {
      super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    }

    func setupData(_ model: AQIModel) {
        lblCity.text = model.city
        lblAQI.text =  model.aqiValue
        bgView.backgroundColor = model.aqiType.color
        lblQuality.text = "Quality : " + model.aqiType.title
        lblNote.text = "Health Tips : " + model.aqiType.notes
    }
}
