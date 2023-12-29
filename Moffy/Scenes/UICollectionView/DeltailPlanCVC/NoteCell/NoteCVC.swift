//
//  NoteCVC.swift
//  Moffy
//
//  Created by MRX on 25/12/2023.
//

import UIKit

class NoteCVC: BaseCollectionViewCell {
  
  @IBOutlet weak var noteTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configData(with text: String) {
    if text.isEmpty {
      self.noteTextView.isHidden = true
    }else {
      self.noteTextView.text = "Note: \(text)"
    }
  }
}
