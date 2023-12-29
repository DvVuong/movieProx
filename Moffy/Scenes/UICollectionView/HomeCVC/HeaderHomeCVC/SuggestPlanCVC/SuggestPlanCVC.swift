//
//  SuggestPlanCVC.swift
//  Moffy
//
//  Created by MRX on 21/12/2023.
//

import UIKit
import FSPagerView

protocol SuggestPlanCVCDelegate: AnyObject {
    func didAddToPlan(_ plan: PlanModel)
}

class SuggestPlanCVC: FSPagerViewCell {
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var namePlanLabel: UILabel!
    @IBOutlet weak var moviesLabel: UILabel!
    @IBOutlet weak var generMoviesLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var viewNamePlan: UIView!
    @IBOutlet weak var imageAddToList: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    private var planItem: PlanModel?
    weak var delegate: SuggestPlanCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupTapGesture()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.gradientView.gradienBorder([UIColor(rgb: 0xFFFFFF),
                                    UIColor(rgb: 0x466FE9),
                                    UIColor(rgb: 0x5367E7),
                                    UIColor(rgb: 0x665BE5),
                                    UIColor(rgb: 0x7E4CE3)])
    }
    
    private func setupUI() {
        self.imageMovie.setConerRadius(24)
        self.viewNamePlan.setBoderWidth(with: 0, numberRadius: 12.0)
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.layer.shadowColor = UIColor.clear.cgColor
        self.contentView.layer.shadowRadius = .zero
        self.contentView.layer.shadowOpacity = .zero
        self.contentView.layer.shadowOffset = .zero
    }
    
    func configData(with plan: PlanModel) {
        self.namePlanLabel.text = plan.titlePlan
        self.moviesLabel.text = "\(plan.movie.count) Movies"
        self.startDateLabel.text = "Start: \(plan.startDate.asStringPDF())"
        self.endDateLabel.text = "End: \(plan.endDate.asStringPDF())"
        self.planItem = plan
        
        let path = plan.movie.map({$0.posterPath ?? ""}).first
        self.imageMovie.loadImage(with: path ?? "")
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))
        self.imageAddToList.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapGesture(_ sender: UITapGestureRecognizer) {
        guard let planItem else {return}
        self.delegate?.didAddToPlan(planItem)
    }
}
