//
//  BottomCreatePlanCVC.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

protocol BottomCreatePlanCVCDelegate: AnyObject {
  func textInputCompleted(with text: String)
  func didTapDoneButton()
}

class BottomCreatePlanCVC: BaseCollectionViewCell {
  @IBOutlet weak var noteTextView: UITextView!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var subView: UIView!
  
  private var text: String = ""
  weak var delegate: BottomCreatePlanCVCDelegate?
  
  override func setProperties() {
    self.doneButton.cornerradius()
    self.doneButton.createGradientLayer()
    self.subView.setBoderWidth()
    self.noteTextView.delegate = self
  }
  
  @IBAction func didTapDoneButton(_ sender: Any) {
    self.delegate?.textInputCompleted(with: text)
    self.delegate?.didTapDoneButton()
  }
}

extension BottomCreatePlanCVC: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    self.noteTextView.text = ""
  }
  func textViewDidChange(_ textView: UITextView) {
    self.text = textView.text
  }
}
