//
//  SuggestCVC.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit

class SuggestCVC: BaseCollectionViewCell {
  @IBOutlet weak var imageMovie: UIImageView!
  @IBOutlet weak var viewBottomGradient: UIView!
  @IBOutlet weak var nameMovie: UILabel!
  @IBOutlet weak var tagGener1: UILabel!
  @IBOutlet weak var tagGener2: UILabel!
  @IBOutlet weak var elipImage: UIImageView!
  @IBOutlet weak var subView: UIView!
  
  override func setProperties() {
    elipImage.isHidden = false
    imageMovie.layer.cornerRadius = 18
    imageMovie.layer.masksToBounds = true
    imageMovie.contentMode = .scaleToFill
    
    viewBottomGradient.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    viewBottomGradient.layer.cornerRadius = 18
    viewBottomGradient.layer.masksToBounds = true
  }
  
  override func setColor() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = viewBottomGradient.bounds
    let color1 = UIColor(rgb: 0x0000, alpha: 0.05).cgColor
    let color2 = UIColor(rgb: 0x0000, alpha: 0.7).cgColor
    gradientLayer.colors = [color1, color2]
    gradientLayer.locations = [0, 0.69]
    viewBottomGradient.layer.insertSublayer(gradientLayer, at: 0)
    subView.gradienBorder([UIColor(rgb: 0x2385EC), UIColor(rgb: 0x7E4CE3)])
  }
  
  func configDataMovie(with movie: Movie) {
    if movie.title == nil {
      self.nameMovie.text = movie.name ?? "None"
    }else {
      self.nameMovie.text = movie.title ?? "None"
    }
    
    imageMovie.loadImage(with: movie.posterPath ?? "")
    let tag1 = MovieManager.shared.getGenersName(with: movie.genreIds[safe: 0] ?? 0)
    let tag2 = MovieManager.shared.getGenersName(with: movie.genreIds[safe: 1] ?? 0)
    
    tagGener1.text = tag1
    tagGener2.text = tag2
  }
  
  func configDataTvShow(with tvShow: Movie) {
    self.nameMovie.text = tvShow.name ?? "None"
    imageMovie.loadImage(with: tvShow.posterPath ?? "")
    
    let tag1 = MovieManager.shared.getGenersName(with: tvShow.genreIds[safe: 0] ?? 0)
    let tag2 = MovieManager.shared.getGenersName(with: tvShow.genreIds[safe: 1] ?? 0)
    
    tagGener1.text = tag1
    tagGener2.text = tag2
  }
  
  func selected() {
    subView.isHidden = false
  }
  
  func deSelected() {
    subView.isHidden = true
  }
}
