//
//  SearchMoviesCVC.swift
//  Moffy
//
//  Created by MRX on 26/12/2023.
//

import UIKit

class SearchMoviesCVC: BaseCollectionViewCell {
  
  @IBOutlet weak var titleNameLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var data: [Movie] = [] {
    willSet {
      self.data = newValue
      self.collectionView.reloadData()
    }
  }
  
  override func setProperties() {
    self.collectionView.registerNib(ofType: SuggestCVC.self)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.reloadData()
  }
}

extension SearchMoviesCVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: SuggestCVC.self, indexPath: indexPath)
    let item = self.data[indexPath.row]
    cell.configDataMovie(with: item)
    cell.deSelected()
    return cell
  }
}

extension SearchMoviesCVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 146.0, height: 198.0)
  }
}
