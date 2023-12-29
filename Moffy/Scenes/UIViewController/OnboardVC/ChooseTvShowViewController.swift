//
//  ChooseTvShowViewController.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit

class ChooseTvShowViewController: BaseViewController {
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var generTvShowCollectionView: UICollectionView!
  @IBOutlet weak var nextButton: UIButton!
  
  override func setProperties() {
    self.nextButton.cornerradius()
    self.nextButton.isEnabled = false
    
    self.generTvShowCollectionView.delegate = self
    self.generTvShowCollectionView.dataSource = self
    self.generTvShowCollectionView.registerNib(ofType: OnboradCVC.self)
  }
  
  override func binding() {
    TvShowManager.shared.$geners
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        
        self.generTvShowCollectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    TvShowManager.shared.$cacheGeners
      .receive(on: DispatchQueue.main)
      .sink { [weak self] item in
        guard let self else {
          return
        }
        
        if item.count >= 2 {
          self.nextButton.isEnabled = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.nextButton.setTitle("NEXT", for: .normal)
            self.nextButton.createGradientLayer(with: UIColor(named: "#7E4CE3")!, endColor: UIColor(named: "#2385EC")!)
          }
        }
        
        if item.count > 5 {
          self.showPopup()
        }
        self.generTvShowCollectionView.reloadData()
      }
      .store(in: &subscriptions)
  }
  
  private func showPopup() {
    let vc = PopupVC(with: "Maximum 5 selected genres")
    vc.modalPresentationStyle = .overFullScreen
    self.present(to: vc, animated: true)
  }
  
  @IBAction func didtapNextButton(_ sender: Any) {
    self.goToSuggestMovieVC()
  }
  
  @IBAction func didTapSkipButton(_ sender: Any) {
    self.goToSuggestMovieVC()
  }
  
  private func goToSuggestMovieVC() {
    let vc = SuggestMovieVC()
    self.push(to: vc, animated: true)
  }
}

extension ChooseTvShowViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard TvShowManager.shared.cacheGeners.count <= 5 else  {
      return
    }
    let item = TvShowManager.shared.geners[indexPath.row]
    TvShowManager.shared.save(with: item)
  }
}

extension ChooseTvShowViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TvShowManager.shared.geners.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = generTvShowCollectionView.dequeue(ofType: OnboradCVC.self, indexPath: indexPath)
    
    let item = TvShowManager.shared.geners[indexPath.row]
    cell.configDataTvShow(with: item)
    
    if TvShowManager.shared.isSelectedGenerTVShow(tvshow: item) {
      cell.selected()
    }else {
      cell.deselected()
    }
    return cell
  }
}

extension ChooseTvShowViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 141, height: 46)
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
    return 16
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 17
  }
}
