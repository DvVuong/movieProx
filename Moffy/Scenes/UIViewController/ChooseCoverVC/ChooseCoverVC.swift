//
//  ChooseCoverVC.swift
//  Moffy
//
//  Created by MRX on 22/12/2023.
//

import UIKit
import PullToRefreshKit

protocol ChooseCoverVCDelegate: AnyObject {
  func didChooseCover(with item: Movie)
  func didChooseMovie(with movies: [Movie])
}

class ChooseCoverVC: BaseViewController {
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var movieButton: UIButton!
  @IBOutlet weak var lineMovie: UIImageView!
  @IBOutlet weak var tvShowButton: UIButton!
  @IBOutlet weak var lineTvShow: UIImageView!
  @IBOutlet weak var titileLabel: UILabel!
  @IBOutlet weak var addButtonMovie: UIButton!
  @IBOutlet weak var bottomLayoutContraint: NSLayoutConstraint!
  
  private var isChangeTvShow: Bool = true
  weak var delegate: ChooseCoverVCDelegate?
  private var titleVC: String = ""
  private var bottomContrain: CGFloat = 0
  private var isShowAddButton: Bool = true
  private var query: String = ""
  
  
  var isChooseMovie: Bool = false
  
  convenience init(title: String, contans: CGFloat = 0, isShowAddButton: Bool = false) {
    self.init()
    self.titleVC = title
    self.bottomContrain = contans
    self.isShowAddButton = isShowAddButton
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if self.isChooseMovie {
      MovieManager.shared.removeMovieLike()
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    MovieManager.shared.removeSearchMovie()
  }
  
  override func setProperties() {
    
    self.tvShowButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 12)
    
    self.tvShowButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 16)
    
    self.lineMovie.isHidden = false
    self.lineTvShow.isHidden = true
    self.bottomLayoutContraint.constant = bottomContrain
    
    self.addButtonMovie.createGradientLayer()
    self.addButtonMovie.cornerradius()
    self.addButtonMovie.isHidden = isShowAddButton
    
    self.titileLabel.text = titleVC
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.registerNib(ofType: SuggestCVC.self)
    
    //MARK: - LoadMore
    self.collectionView.configRefreshFooter(container: self) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.collectionView.switchRefreshFooter(to: .normal)
        if self.isChangeTvShow {
          MovieManager.shared.searchMovie(with: self.query)
        }else {
          TvShowManager.shared.searchTvShow(with: self.query)
        }
      }
    }
  }
  
  override func setColor() {
    searchBar.layer.borderWidth = 1
    searchBar.layer.borderColor = UIColor(rgb: 0xFFFFFF).cgColor
    searchBar.tintColor = .white
    searchBar.barTintColor = UIColor(rgb: 0x595959)
    searchBar.layer.cornerRadius = 24
    searchBar.searchTextField.backgroundColor = .clear
    searchBar.searchTextField.textColor = .white
    searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Type to search"
                                                                         ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFFFFFF, alpha: 0.3)])
    searchBar.clipsToBounds = true
    searchBar.setImage(UIImage(named: "iconSearchVC"), for: .search, state: .normal)
    searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
    searchBar.delegate = self
  }
  
  override func binding() {
    MovieManager.shared.$topRateMovies
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {return}
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$movieGeners
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$movieLikes
      .receive(on: DispatchQueue.main)
      .sink { [weak self] item in
        guard let self = self else {return}
        guard !item.isEmpty else  {
          return
        }
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$seclectedMovies
      .receive(on: DispatchQueue.main)
      .sink { [weak self] item in
        guard let self = self else {return}
        
        guard !item.isEmpty else  {
          self.addButtonMovie.setTitle("Add", for: .normal)
          return
        }
        self.addButtonMovie.setTitle("Add (\(item.count))", for: .normal)
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$searchMovie
      .receive(on: DispatchQueue.main)
      .sink { [weak self] item in
        guard let self else {
          return
        }
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    TvShowManager.shared.$searchTvShow
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    TvShowManager.shared.$tvShowLike
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self = self else {return}
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
  }
  
  private func showPopup() {
    let popupVC = PopupVC(with: "Maximum 20 movies/tv show")
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(to: popupVC, animated: true)
  }
  
  @IBAction func didTapBackButton(_ sender: Any) {
    self.pop(animated: true)
  }
  
  @IBAction func didTapMovieButton(_ sender: Any) {
    self.lineMovie.isHidden = false
    self.lineTvShow.isHidden = true
    self.tvShowButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 12)
    self.tvShowButton.tintColor = UIColor(rgb: 0x8E8E8E)
    
    self.movieButton.tintColor = UIColor(rgb: 0xFDFDFD)
    self.movieButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 16)
    
    self.isChangeTvShow.toggle()
    self.collectionView.reloadData()
  }
  
  @IBAction func didTapTvShowButton(_ sender: Any) {
    self.lineMovie.isHidden = true
    self.lineTvShow.isHidden = false
    
    self.tvShowButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 16)
    self.tvShowButton.tintColor = UIColor(rgb: 0xFDFDFD)
    
    self.movieButton.titleLabel?.font = UIFont(name: "Quicksand-Regular", size: 12)
    self.movieButton.tintColor = UIColor(rgb: 0x8E8E8E)
    
    self.isChangeTvShow.toggle()
    self.collectionView.reloadData()
  }
  
  @IBAction func didTapAddButton(_ sender: Any) {
    let movies = MovieManager.shared.seclectedMovies
    self.delegate?.didChooseMovie(with: movies)
    self.popVC()
  }
  
  private func popVC() {
    self.pop(animated: true)
  }
}

extension ChooseCoverVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = MovieManager.shared.topRateMovies[indexPath.row]
    let tvShow = TvShowManager.shared.topRateTvShow[indexPath.row]
    
    if self.isChooseMovie {
      guard MovieManager.shared.seclectedMovies.count < 20 else  {
        self.showPopup()
        return
      }
      if self.isChangeTvShow {
        MovieManager.shared.setSelectedMovie(movie: movie)
      }else {
        MovieManager.shared.setSelectedMovie(movie: tvShow)
      }
      
    }else {
      if self.isChangeTvShow {
        MovieManager.shared.removeMovieLike()
        MovieManager.shared.setMovieLike(movie: movie)
        self.delegate?.didChooseCover(with: movie)
        
        self.popVC()
      }else {
        TvShowManager.shared.removeTvShowLike()
        TvShowManager.shared.setTvShowLike(tvShow: tvShow)
        self.delegate?.didChooseCover(with: tvShow)
        self.popVC()
      }
    }
  }
}

extension ChooseCoverVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if self.isChangeTvShow {
      return MovieManager.shared.topRateMovies.count
    }else {
      return TvShowManager.shared.searchTvShow.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if self.isChangeTvShow {
      let cell = collectionView.dequeue(ofType: SuggestCVC.self, indexPath: indexPath)
      let movie = MovieManager.shared.topRateMovies[indexPath.row]
      cell.configDataMovie(with: movie)
      guard !self.isChooseMovie else  {
        if MovieManager.shared.isSelected(with: MovieManager.shared.seclectedMovies, movie: movie)  {
          cell.selected()
        }else {
          cell.deSelected()
        }
        return cell
      }
      
      if MovieManager.shared.isSelected(with: MovieManager.shared.movieLikes, movie: movie) {
        cell.selected()
      }else {
        cell.deSelected()
      }
      return cell
      
    }else {
      let cell = collectionView.dequeue(ofType: SuggestCVC.self, indexPath: indexPath)
      let tvShow = TvShowManager.shared.searchTvShow[indexPath.row]
      cell.configDataTvShow(with: tvShow)
      guard !self.isChooseMovie else  {
        if MovieManager.shared.isSelected(with: MovieManager.shared.seclectedMovies, movie: tvShow)  {
          cell.selected()
        }else {
          cell.deSelected()
        }
        return cell
      }
      
      if TvShowManager.shared.isSelected(tvShow: tvShow) {
        cell.selected()
      }else {
        cell.deSelected()
      }
      
      return cell
    }
  }
}

extension ChooseCoverVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing: CGFloat = 19.0
    let widthItem = (self.collectionView.frame.width - spacing) / 2
    return CGSize(width: widthItem, height: 198.0)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 18.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }
}

extension ChooseCoverVC: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.query = searchBar.text ?? ""
    MovieManager.shared.searchMovie(with: searchBar.text ?? "nil")
    TvShowManager.shared.searchTvShow(with: searchBar.text ?? "nil")
    searchBar.resignFirstResponder()
  }
}
