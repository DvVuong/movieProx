//
//  BottomHomeCVC.swift
//  Moffy
//
//  Created by MRX on 21/12/2023.
//

import UIKit

class BottomHomeCVC: BaseCollectionViewCell {
    @IBOutlet weak var imageEditPlan: UIImageView!
    @IBOutlet weak var namePlanLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var subView: UIView!
    
    private var planItem: PlanModel?
    var movieHandler: ((PlanModel) -> Void)? = nil
    
    override func setProperties() {
        self.imageMovie.setConerRadius(10)
        self.subView.setBoderWidth(with: 0, numberRadius: 10)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageEdit(_:)))
        imageEditPlan.addGestureRecognizer(tapGesture)
    }
    
    func configData(with plan: PlanModel) {
        self.namePlanLabel.text = plan.titlePlan
        self.startDate.text = "Start: \(plan.startDate.asStringPDF())"
        self.endDateLabel.text = "End: \(plan.endDate.asStringPDF())"
        if plan.imageCoverPlan == nil {
            let path = plan.movie.map({$0.posterPath ?? ""}).first
            self.imageMovie.loadImage(with: path ?? "")
        }else {
            self.imageMovie.loadImage(with: plan.imageCoverPlan ?? "")
        }
        self.planItem = plan
    }
    
    @objc private func didTapImageEdit(_ sender: UITapGestureRecognizer) {
        guard let planItem = planItem else {
            return
        }
        self.movieHandler?(planItem)
    }
}
