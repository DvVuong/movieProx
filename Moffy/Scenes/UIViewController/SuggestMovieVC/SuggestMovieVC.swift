//
//  SuggestMovieVC.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit
import PullToRefreshKit

class SuggestMovieVC: BaseViewController {
  @IBOutlet weak var viewSearch: UIView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var lineMovie: UIImageView!
  @IBOutlet weak var lineTvShow: UIImageView!
  @IBOutlet weak var tvShowButton: UIButton!
  @IBOutlet weak var movieButton: UIButton!
  
  private var datas: [Movie] = []
  private var switchTvshowMovie: Bool = true
  private var query: String = ""
  private var isSearchMovie: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    MovieManager.shared.fecthTopRateMovie()
//    TvShowManager.shared.fecthTvShowToprate()
    MovieManager.shared.fecthMovie(.topRateMovie, page: "1")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    MovieManager.shared.removeSearchMovie()
    TvShowManager.shared.removeSearchTvShow()
    MovieManager.shared.removeGenerMovie()
    MovieManager.shared.removeMovieLike()
  }
  
  override func setColor() {
    searchBar.layer.borderColor = UIColor(rgb: 0xFFFFFF).cgColor
    searchBar.tintColor = .white
    searchBar.barTintColor = UIColor(rgb: 0x595959)
    
    searchBar.searchTextField.backgroundColor = .clear
    searchBar.searchTextField.textColor = .white
    searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Type to search"
                                                                         ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFFFFFF, alpha: 0.3)])
    
    searchBar.setImage(UIImage(named: "iconSearchVC"), for: .search, state: .normal)
    searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
  }
  
  override func setProperties() {
    self.searchBar.delegate = self
    self.searchBar.layer.borderWidth = 1
    self.searchBar.layer.cornerRadius = 24
    self.searchBar.clipsToBounds = true
    
    self.nextButton.cornerradius()
    self.nextButton.createGradientLayer()
    
    self.lineTvShow.isHidden = true
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.registerNib(ofType: SuggestCVC.self)
    
    self.collectionView.configRefreshFooter(container: self) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.collectionView.switchRefreshFooter(to: .normal)
        if self.switchTvshowMovie {
          MovieManager.shared.fecthTopRateMovie()
          MovieManager.shared.searchMovie(with: self.query)
          
        }else {
          TvShowManager.shared.searchTvShow(with: self.query)
          TvShowManager.shared.fecthTvShowToprate()
        }
      }
    }
    self.view.hideKeyboardWhenTappedAround()
  }
  
  override func binding() {
    MovieManager.shared.$topRateMovies
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {return}
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$searchMovie
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {return}
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$movieGeners
      .receive(on: DispatchQueue.main)
      .sink { [weak self] item in
        guard let self else {
          return
        }
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$movieLikes
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self = self else {return}
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
    
    TvShowManager.shared.$searchTvShow
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self = self else {return}
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
  }
  
  @IBAction func didTapNextButton(_ sender: Any) {
    self.goToMainTabbarVC()
    PlanManager.shared.getRandomMoviesLike()
  }
  
  @IBAction func didTapMovie(_ sender: Any) {
    self.tvShowButton.setTitleColor(UIColor(rgb: 0x8E8E8E), for: .normal)
    self.movieButton.setTitleColor(UIColor(rgb: 0xFDFDFD), for: .normal)
    lineTvShow.isHidden = true
    lineMovie.isHidden = false
    switchTvshowMovie.toggle()
    self.collectionView.reloadData()
  }
  
  @IBAction func didTapTVShow(_ sender: Any) {
    lineTvShow.isHidden = false
    lineMovie.isHidden = true
    self.movieButton.setTitleColor(UIColor(rgb: 0x8E8E8E), for: .normal)
    self.tvShowButton.setTitleColor(UIColor(rgb: 0xFDFDFD), for: .normal)
    self.collectionView.reloadData()
    switchTvshowMovie.toggle()
  }
  
  @IBAction func didTapSkipButton(_ sender: Any) {
    self.goToMainTabbarVC()
    PlanManager.shared.getRandomeMovieGener()
  }
  
  private func goToMainTabbarVC() {
    let homevc = MainTabbarVC()
    self.push(to: homevc, animated: true)
  }
}

extension SuggestMovieVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if isSearchMovie {
      if switchTvshowMovie {
        let movie = MovieManager.shared.searchMovie[indexPath.row]
        MovieManager.shared.setMovieLike(movie: movie)
      }else {
        let tvShow = TvShowManager.shared.searchTvShow[indexPath.row]
        TvShowManager.shared.setTvShowLike(tvShow: tvShow)
      }
    }else {
      if switchTvshowMovie {
        let movie = MovieManager.shared.movieGeners[indexPath.row]
        MovieManager.shared.setMovieLike(movie: movie)
      }else {
        let tvshow = TvShowManager.shared.tvShowGener[indexPath.row]
        TvShowManager.shared.setTvShowLike(tvShow: tvshow)
      }
    }
  }
}

extension SuggestMovieVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if self.isSearchMovie {
      if switchTvshowMovie {
        return MovieManager.shared.searchMovie.count
      }else {
        return TvShowManager.shared.searchTvShow.count
      }
    }else {
      if switchTvshowMovie {
        return MovieManager.shared.movieGeners.count
      }else {
        return TvShowManager.shared.tvShowGener.count
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: SuggestCVC.self, indexPath: indexPath)
    if isSearchMovie {
      let movie = MovieManager.shared.searchMovie[indexPath.row]
      cell.configDataMovie(with: movie)
      if MovieManager.shared.isSelected(with: MovieManager.shared.movieLikes, movie: movie) {
        cell.selected()
      }else {
        cell.deSelected()
      }
      return cell
    }else {
      if switchTvshowMovie {
        let movie = MovieManager.shared.movieGeners[indexPath.row]
        cell.configDataMovie(with: movie)
        if MovieManager.shared.isSelected(with: MovieManager.shared.movieLikes, movie: movie) {
          cell.selected()
        }else {
          cell.deSelected()
        }
        
      }else {
        if isSearchMovie {
          let tvShow = TvShowManager.shared.searchTvShow[indexPath.row]
          cell.configDataTvShow(with: tvShow)
          if TvShowManager.shared.isSelected(tvShow: tvShow) {
            cell.selected()
          }else {
            cell.deSelected()
          }
        }else {
          let tvshow = TvShowManager.shared.tvShowGener[indexPath.row]
          cell.configDataTvShow(with: tvshow)
          if TvShowManager.shared.isSelected(tvShow: tvshow) {
            cell.selected()
          }else {
            cell.deSelected()
          }
        }
      }
    }
    return cell
  }
}

extension SuggestMovieVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let spacingItem: CGFloat = 19
    let widthItem = (collectionView.frame.width - spacingItem) / 2
    return CGSize(width: widthItem, height: 198)
  }
  
  func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 18
  }
  
  func collectionView(_ collectionView: UICollectionView, 
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
}

extension SuggestMovieVC {
  @objc private func textFieldDidChange(_ sender: UITextField) {
    
  }
}

extension SuggestMovieVC: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.query = searchBar.text ?? ""
    MovieManager.shared.searchMovie(with: searchBar.text ?? "")
    TvShowManager.shared.searchTvShow(with: searchBar.text ?? "")
    self.isSearchMovie = true
    searchBar.resignFirstResponder()
  }
}
