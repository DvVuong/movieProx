//
//  ChooseMoviCVC.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

protocol MoviesCVCDelegate: AnyObject {
  func didRemoveMovieAtIndex(at index: Int)
}

class MoviesCVC: BaseCollectionViewCell {
  @IBOutlet weak var imageMovie: UIImageView!
  @IBOutlet weak var nameMovie: UILabel!
  @IBOutlet weak var generLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var noteTextView: UITextView!
  
  weak var delegate: MoviesCVCDelegate?
  private var indexMovie: Int = 0
  
  override func setProperties() {
    imageMovie.setConerRadius()
  }
  
  func configData(with movie: Movie, index: Int) {
    self.indexMovie = index
    self.imageMovie.loadImage(with: movie.backdropPath ?? "")
    
    if movie.title == nil {
      self.nameMovie.text = movie.name ?? ""
      let generID = movie.genreIds.first ?? 0
      let nameGener = TvShowManager.shared.getGenersName(with: generID)
      self.generLabel.text = nameGener
    }else {
      self.nameMovie.text = movie.title ?? ""
      let generID = movie.genreIds.first ?? 0
      let nameGener = MovieManager.shared.getGenersName(with: generID)
      self.generLabel.text = nameGener
    }
    
    if movie.releaseDate == nil {
      self.yearLabel.text = "\(movie.firstAirDate?.converStringToDate() ?? 0)"
    }else {
      self.yearLabel.text = "\(movie.releaseDate?.converStringToDate() ?? 0)"
    }
  }
  
  func bindingData(_ note: String) {
    self.noteTextView.text = note
  }
  
  @IBAction func didTapDeleteButton(_ sender: Any) {
    self.delegate?.didRemoveMovieAtIndex(at: indexMovie)
  }
}
