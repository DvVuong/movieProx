//
//  BodyCreatePlanCVCe.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

protocol BodyCreatePlanCVCDelegate: AnyObject {
  func textInputNamePlanCompleted(with text: String)
  func didChooseMovie()
  func didChooseStartDate()
  func didChooseEndDate()
}

class BodyCreatePlanCVC: BaseCollectionViewCell {
  @IBOutlet weak var viewStartPlan: UIView!
  @IBOutlet weak var viewEndPlan: UIView!
  @IBOutlet weak var viewNamePlan: UIView!
  @IBOutlet weak var imagePlusMovie: UIImageView!
  @IBOutlet weak var chooseStartDateButton: UIButton!
  @IBOutlet weak var chooseEndPlanDateButton: UIButton!
  @IBOutlet weak var inputNamePlan: UITextView!
  @IBOutlet weak var startDateLabel: UILabel!
  @IBOutlet weak var endDateLabel: UILabel!
  
  private var namePlan: String = ""
  
  weak var delegate: BodyCreatePlanCVCDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setUpGesTure()
  }
  
  override func setProperties() {
    self.viewStartPlan.setBoderWidth()
    self.viewEndPlan.setBoderWidth()
    self.viewNamePlan.setBoderWidth()
    self.inputNamePlan.delegate = self
  }
  
  func bindData(with startDate: Date, endDate: Date) {
    self.startDateLabel.text = startDate.asStringPDF()
    self.endDateLabel.text = endDate.asStringPDF()
  }
  
  private func setUpGesTure() {
    let gesTure = UITapGestureRecognizer(target: self, action: #selector(didTapChooseMovie(_:)))
    imagePlusMovie.addGestureRecognizer(gesTure)
  }
  
  @objc private func didTapChooseMovie(_ sender: Any) {
    self.delegate?.didChooseMovie()
  }
  
  @IBAction func didTapChooseStartDate(_ sender: Any) {
    self.delegate?.didChooseStartDate()
  }
  
  @IBAction func didTapChooseEndDate(_ sender: Any) {
    self.delegate?.didChooseEndDate()
  }
}

extension BodyCreatePlanCVC: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    self.inputNamePlan.text = ""
  }
  func textViewDidChange(_ textView: UITextView) {
    self.namePlan = textView.text
    self.delegate?.textInputNamePlanCompleted(with: textView.text)
  }
}
