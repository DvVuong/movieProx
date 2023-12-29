//
//  BodyDetailPlanCVC.swift
//  Moffy
//
//  Created by MRX on 25/12/2023.
//

import UIKit

class BodyDetailPlanCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(with plan: PlanModel) {
        self.startDateLabel.text = plan.startDate.asStringPDF()
        self.endDateLabel.text = plan.endDate.asStringPDF()
    }
}
