//
//  MonthCVC.swift
//  Moffy
//
//  Created by MRX on 27/12/2023.
//

import UIKit

class MonthCVC: BaseCollectionViewCell {
  @IBOutlet weak var monthButton: UIButton!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var subView: UIView!
  
  private var month: Int = 0
  private var year: String = ""
  var handlerChooseItem: ((Int, String) -> Void)? = nil
 
  override func setColor() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.monthButton.bounds
    gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.colors = [UIColor(rgb: 0x7E4CE3).cgColor,
                            UIColor(rgb: 0x2385EC).cgColor,
                            UIColor(rgb: 0x2385EC, alpha: 1).cgColor]
    gradientLayer.locations = [0, 1.85, 1.85]
    gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 2.77, b: 1, c: -1, d: 2.77, tx: 0.5, ty: 0))
    self.subView.layer.addSublayer(gradientLayer)
  }
  
  override func setProperties() {
    self.subView.isHidden = true
    self.subView.conerRadius(with: 13)
  }
  
  func bindingData(_ month: String, index: Int) {
    self.year = month
    self.month = index + 1
    self.monthButton.setTitle(month, for: .normal)
  }
  
  @IBAction func didTapChooseMonth(_ sender: Any) {
    handlerChooseItem?(self.month, year)
  }

  func selected() {
    self.subView.isHidden = false
    self.monthButton.setTitleColor(UIColor(rgb: 0xFBF9FF), for: .normal)
    self.monthButton.titleLabel?.font = UIFont(name: "Quicksand-Bold", size: 14)
  }
  
  func deSelected() {
    self.subView.isHidden = true
    self.monthButton.setTitleColor(UIColor(rgb: 0x595959), for: .normal)
    self.monthButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 14)
  }
}
