//
//  OnboardVC.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import UIKit

class OnboardVC: BaseViewController {
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var titlePickType: UILabel!
  @IBOutlet weak var titleStepLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var genresCollectionView: UICollectionView!
  @IBOutlet weak var toastLabel: UILabel!
  
  override func setProperties() {
    self.toastLabel.isHidden = true
    self.nextButton.cornerradius()
    self.nextButton.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
    self.nextButton.isEnabled = false
    self.skipButton.addTarget(self, action: #selector(didTapSkipButton(_:)), for: .touchUpInside)
    self.genresCollectionView.delegate = self
    self.genresCollectionView.dataSource = self
    self.genresCollectionView.isHidden = false
    self.genresCollectionView.registerNib(ofType: OnboradCVC.self)
  }
  
  override func binding() {
    MovieManager.shared.$geners
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        self.genresCollectionView.reloadData()
      }
      .store(in: &subscriptions)
    
    MovieManager.shared.$cacheGeners
      .receive(on: DispatchQueue.main)
      .sink { [weak self] item in
        guard let self else {
          return
        }
        
        if item.count >= 2 {
          self.toastLabel.isHidden = false
          self.nextButton.isEnabled = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.nextButton.setTitle("NEXT", for: .normal)
            self.nextButton.createGradientLayer(with: UIColor(named: "#7E4CE3")!, endColor: UIColor(named: "#2385EC")!)
          }
        }
        
        if item.count > 5 {
          self.showPopup()
        }
        
        self.genresCollectionView.reloadData()
      }
      .store(in: &subscriptions)
    
//    MovieManager.shared.$cacheGennerStruct
//      .subscribe(on: DispatchQueue.main)
//      .sink { [weak self] _ in
//        self?.genresCollectionView.reloadData()
//      }
//      .store(in: &subscriptions)
  }
  
  private func showPopup() {
    let vc = PopupVC(with: "Maximum 5 selected genres")
    vc.modalPresentationStyle = .overFullScreen
    self.present(to: vc, animated: true)
  }
  
  @objc private func didTapNextButton(_ sender: UIButton) {
    goToTvShowController()
  }
  
  @objc private func didTapSkipButton(_ sender: UIButton) {
    goToTvShowController()
  }
  
  private func goToTvShowController() {
    let vc = ChooseTvShowViewController()
    self.push(to: vc, animated: true)
  }
}

extension OnboardVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard MovieManager.shared.cacheGeners.count <= 5 else  {
      return
    }
    let item = MovieManager.shared.geners[indexPath.row]
    MovieManager.shared.save(gener: item, image: UIImage())
  }
}

extension OnboardVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MovieManager.shared.geners.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = genresCollectionView.dequeue(ofType: OnboradCVC.self, indexPath: indexPath)
    let item = MovieManager.shared.geners[indexPath.row]
    cell.configData(with: item, index: indexPath.row)
    
    if MovieManager.shared.isSelectedGener(gener: item) {
      let index = MovieManager.shared.getIndexForSelectedGener()
      cell.bindImage(with: index)
      cell.selected()
    }else {
      cell.deselected()
    }
    return cell
  }
  
}

extension OnboardVC: UICollectionViewDelegateFlowLayout {
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

