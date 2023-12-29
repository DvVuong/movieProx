//
//  CreatePlanCVC.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

class CreatePlanCVC: BaseCollectionViewCell {
  @IBOutlet weak var subView: UIView!
  @IBOutlet weak var imageChooseCover: UIImageView!
  @IBOutlet weak var imageCover: UIImageView!
  @IBOutlet weak var viewText: UIView!
  @IBOutlet weak var choosePlanLabel: UILabel!
  
  var handler: Handler?
  private var selectedImage: UIImageView?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupTapGesture()
  }
  
  override func setProperties() {
    self.subView.setBoderWidth(with: 0)
    self.viewText.addDashedBorder()
    self.viewText.isHidden = true
  }
  
  private func setupTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChooseCover(_:)))
    self.imageChooseCover.addGestureRecognizer(tapGesture)
    
    let tapGetureImage = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))
    self.viewText.addGestureRecognizer(tapGetureImage)
  }
  
  func configData(with movie: Movie) {
    self.imageCover.loadImage(with: movie.backdropPath ?? "")
    self.viewText.isHidden = false
    self.imageChooseCover.isHidden = true
    self.choosePlanLabel.isHidden = true
  }
  
  @objc private func didTapChooseCover(_ sender: UITapGestureRecognizer) {
    self.handler?()
  }
  
  @objc private func didTapGesture(_ sender: UITapGestureRecognizer) {
    self.handler?()
  }
}
