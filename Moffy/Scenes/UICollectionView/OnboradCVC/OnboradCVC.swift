//
//  OnboradCVC.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import UIKit

class OnboradCVC: BaseCollectionViewCell {
  @IBOutlet weak var nameGenersButton: UILabel!
  @IBOutlet weak var image: UIImageView!
  
  private var itemGenresMovie: GenresMovie? = nil
  private var itemGenersTVShow: GenerTvShowObject? = nil
  private var tagCount: Int = 0
  private var ramdomImage: UIImage?
  private var index: Int = 0
  
  var handelItemGenerMovie: ((GenresMovie, UIImage) -> Void)? = nil
  var handelItemTVShow: ((GenerTvShowObject, UIImage) -> Void)? = nil
  
  private var listIamge: [UIImage] = [UIImage(named: "ColorButton1")!,
                                      UIImage(named: "ColorButton2")!,
                                      UIImage(named: "ColorButton3")!,
                                      UIImage(named: "ColorButton4")!,
                                      UIImage(named: "ColorButton5")!
  ]

  override func setProperties() {
    nameGenersButton.cornerRadius(with: 24)
    self.image.image = UIImage(named: "ColorButton1")
  }
  
  func configData(with data: GenresMovie, index: Int) {

    self.getRandomImage(index)
    self.itemGenresMovie = data
    nameGenersButton.text = data.name
    let num = MovieManager.shared.getIndexForSelectedGener()
    self.image.image = self.listIamge[safe: num]
  }
  
  func bindImage(with index: Int) {
    self.image.image = self.listIamge[safe: index]
  }
  
  func configDataTvShow(with data: GenerTvShow) {
    nameGenersButton.text = data.name
  }
  
  @objc private func didTapButton(_ sender: UIButton) {
    if let item = itemGenresMovie {
      self.handelItemGenerMovie?(item, ramdomImage ?? UIImage())
    }
    
    if let itemGenersTV = itemGenersTVShow, let image = self.ramdomImage {
      self.handelItemTVShow?(itemGenersTV, image)
    }
  }
  
  func selected() {
    self.image.isHidden = false
  }
  
  func deselected() {
    self.image.isHidden = true
  }
  
  func getRandomImage(_ index: Int) {
    if index < self.listIamge.count {
      self.ramdomImage = self.listIamge[index]
    }
  }
}
