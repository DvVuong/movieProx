//
//  SearchCVC.swift
//  Moffy
//
//  Created by MRX on 26/12/2023.
//

import UIKit
import PullToRefreshKit

enum SearchCVCellType {
  case movies
  case tvShow
  case actor
}

class SearchCV: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var topNSlayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var recommendLabel: UILabel!
  @IBOutlet weak var viewNoData: UIView!
  
  private var sections: [SearchCVCellType] = [.movies, .tvShow, .actor]
  private var isShowRecommend: Bool = true
  private var heightForMoviesCell: CGFloat = 248.0
  private var heightForTvShowCell: CGFloat = 248.0
  private var heightForActorCell: CGFloat = 248.0
  private var qurey: String = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    MovieManager.shared.fecthTopRateMovie()
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
  
  override func setProperties() {
    self.viewNoData.isHidden = true
    self.searchBar.delegate = self
    self.collectionView.registerNib(ofType: SearchMoviesCVC.self)
    self.collectionView.registerNib(ofType: SuggestCVC.self)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    
    self.collectionView.configRefreshFooter(container: self) {
      //      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      //        self.collectionView.switchRefreshFooter(to: .normal)
      //        ActorManager.shared.searchActor(with: self.qurey)
      //        MovieManager.shared.searchMovie(with: self.qurey)
      //        TvShowManager.shared.searchTvShow(with: self.qurey)
      //      }
    }
    self.view.hideKeyboardWhenTappedAround()
  }
  
  override func binding() {
    ActorManager.shared.$movie
      .receive(on: DispatchQueue.main)
      .sink { [weak self] actors in
        guard let self else {
          return
        }
        
        if actors.isEmpty {
          self.heightForActorCell = 0.0
        }else {
          self.heightForActorCell = 248.0
        }
        
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    TvShowManager.shared.$searchTvShow
      .receive(on: DispatchQueue.main)
      .sink { [weak self] tvShows in
        guard let self else {
          return
        }
        if tvShows.isEmpty {
          self.heightForTvShowCell = 0.0
        }else {
          self.heightForTvShowCell = 248.0
        }
        
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$searchMovie
      .receive(on: DispatchQueue.main)
      .sink { [weak self] movies in
        guard let self else {
          return
        }
        
        if movies.isEmpty {
          self.heightForMoviesCell = 0.0
        }else {
          self.heightForMoviesCell = 248.0
        }
        
        self.isShowRecommend = self.checkDataEmty(movies)
        
        if self.isShowRecommend {
          self.recommendLabel.isHidden = false
          self.topNSlayoutConstraint.constant = 66
        }else {
          self.recommendLabel.isHidden = true
          self.topNSlayoutConstraint.constant = 16
        }
        
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
    
  }
  
  private func checkDataEmty(_ movies: [Movie]) -> Bool {
    if movies.isEmpty {
      return true
    }else {
      return false
    }
  }
  
  private func showViewNoData() {
    if MovieManager.shared.searchMovie.isEmpty && TvShowManager.shared.searchTvShow.isEmpty && ActorManager.shared.movie.isEmpty  {
      self.viewNoData.isHidden = true
      self.recommendLabel.isHidden = true
    }else {
      self.viewNoData.isHidden = false
      self.recommendLabel.isHidden = true
    }
  }
}

extension SearchCV: UICollectionViewDelegate {
  
}

extension SearchCV: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch sections[section] {
    case .movies:
      if self.isShowRecommend {
        return MovieManager.shared.topRateMovies.count
      }else {
        return 1
      }
      
    case .tvShow:
      return 1
      
    case .actor:
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch sections[indexPath.section] {
    case .movies:
      if self.isShowRecommend {
        let cell = collectionView.dequeue(ofType: SuggestCVC.self, indexPath: indexPath)
        let movie = MovieManager.shared.topRateMovies[indexPath.row]
        cell.configDataMovie(with: movie)
        cell.deSelected()
        return cell
        
      }else {
        let cell = collectionView.dequeue(ofType: SearchMoviesCVC.self, indexPath: indexPath)
        let movies = MovieManager.shared.searchMovie
        cell.titleNameLabel.text = "Movies"
        cell.data = movies
        return cell
      }
      
    case .tvShow:
      let cell = collectionView.dequeue(ofType: SearchMoviesCVC.self, indexPath: indexPath)
      let tvShows = TvShowManager.shared.searchTvShow
      cell.titleNameLabel.text = "TV Show"
      cell.data = tvShows
      return cell
      
    case .actor:
      let cell = collectionView.dequeue(ofType: SearchMoviesCVC.self, indexPath: indexPath)
      if indexPath.section < ActorManager.shared.movie.count {
        let actors = ActorManager.shared.movie
        cell.data = actors
        cell.titleNameLabel.text = "Actor"
      }
      
      return cell
    }
  }
}

extension SearchCV: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch sections[indexPath.section] {
    case .movies:
      if self.isShowRecommend {
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - 32 * 2 - 19) / 2
        return CGSize(width: itemWidth, height: 198.0)
      }else {
        return CGSize(width: self.collectionView.frame.width, height: self.heightForMoviesCell)
      }
    case .tvShow:
      return CGSize(width: self.collectionView.frame.width, height: self.heightForTvShowCell)
    case .actor:
      return CGSize(width: self.collectionView.frame.width, height: self.heightForActorCell)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    if self.isShowRecommend {
      return 19
    }
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch sections[section] {
    case .movies:
      if self.isShowRecommend {
        return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
      }else {
        return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
      }
    case .tvShow:
      return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    case .actor:
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
}

extension SearchCV: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.qurey = searchBar.text ?? ""
    ActorManager.shared.searchActor(with: searchBar.text ?? "")
    MovieManager.shared.searchMovie(with: searchBar.text ?? "")
    TvShowManager.shared.searchTvShow(with: searchBar.text ?? "")
    MovieManager.shared.fecthTopRateMovie()
    searchBar.resignFirstResponder()
  }
}
