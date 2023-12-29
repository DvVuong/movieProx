//
//  DetailPlanVC.swift
//  Moffy
//
//  Created by MRX on 22/12/2023.
//

import UIKit

enum DetailPlanCellType {
  case headerCell
  case bodyCell
  case firstMovie
  case noteCell
  case bottomCell
}

class DetailPlanVC: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var sections: [DetailPlanCellType] = [.headerCell, .bodyCell, .firstMovie , .noteCell, .bottomCell]
  private var plan: PlanModel?
  private var heightCollectionview: CGFloat = 65
  private var numberOFRow: Int = 0
  
  convenience init(with plan: PlanModel) {
    self.init()
    self.plan = plan
  }
  
  override func setProperties() {
    self.collectionView.registerNib(ofType: HeaderPlandetailCVC.self)
    self.collectionView.registerNib(ofType: MoviesCVC.self)
    self.collectionView.registerNib(ofType: NoteCVC.self)
    self.collectionView.registerNib(ofType: BodyDetailPlanCVC.self)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.getHeigthCollectionView()
  }
  
  private func getHeigthCollectionView() {
    let height = 86
    
    guard let numberOfItem = self.plan?.movie.count else {
      self.heightCollectionview += CGFloat(height)
      return
    }
    
    if numberOfItem <= 5 {
      self.numberOFRow = 1
    }else if numberOfItem <= 10 {
      self.numberOFRow = 2
    }else if numberOfItem <= 15 {
      self.numberOFRow = 3
    }else {
      self.numberOFRow = 4
    }
    
    self.heightCollectionview += CGFloat(height) * CGFloat(self.numberOFRow)
  }
  
  @IBAction func didTapBackButton(_ sender: Any) {
    self.pop(animated: true)
  }
  
  @IBAction func didTapEditPlanButton(_ sender: Any) {
  }
}

extension DetailPlanVC: UICollectionViewDelegate {
  
}

extension DetailPlanVC: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch sections[section] {
    case .headerCell:
      return 1
    case .bodyCell:
      return 1
    case .firstMovie:
      return 1
    case .noteCell:
      return 1
    case .bottomCell:
      return self.plan?.movie.count ?? 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch sections[indexPath.section] {
      
    case .headerCell:
      let cell = collectionView.dequeue(ofType: HeaderPlandetailCVC.self, indexPath: indexPath)
      cell.backgroundColor = .green
      return cell
      
    case .bodyCell:
      let cell = collectionView.dequeue(ofType: BodyDetailPlanCVC.self, indexPath: indexPath)
      if let plan = plan {
        cell.configData(with: plan)
      }
      
      return cell
      
    case .firstMovie:
      let cell = collectionView.dequeue(ofType: MoviesCVC.self, indexPath: indexPath)
      let movie = plan?.movie[safe: 0]
      if let movie = movie  {
        cell.configData(with: movie, index: 0)
      }
      return cell
      
    case .noteCell:
      let cell = collectionView.dequeue(ofType: NoteCVC.self, indexPath: indexPath)
      cell.configData(with: plan?.note ?? "")
      return cell
      
    case .bottomCell:
      let cell = collectionView.dequeue(ofType: MoviesCVC.self, indexPath: indexPath)
      let index = indexPath.row + 1
      
      guard index < ((plan?.movie.count ?? 0)) else {
        return cell
      }
      let movie = plan?.movie[index]
      if let movie = movie  {
        cell.configData(with: movie, index: indexPath.row)
      }
      
      return cell
    }
  }
}

extension DetailPlanVC: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch sections[indexPath.section] {
      
    case .headerCell:
      return CGSize(width: self.collectionView.frame.width, height: self.heightCollectionview)
      
    case .bodyCell:
      return CGSize(width: self.collectionView.frame.width, height: 100)
      
    case .bottomCell:
      guard indexPath.row + 1 < plan?.movie.count ?? 0 else {
        return .zero
      }
      
      return CGSize(width: self.collectionView.frame.width, height: 100)
      
    case .noteCell:
      let text = plan?.note ?? ""
      let height = heightForText(text, width: self.collectionView.frame.width)
      return CGSize(width: self.collectionView.frame.width, height: height + 10)
      
    case .firstMovie:
      return CGSize(width: self.collectionView.frame.width, height: 100)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
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
    case.headerCell:
      return.zero
    case .bodyCell:
      return.zero
    case .firstMovie:
      return UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
    case .noteCell:
      return UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
    case .bottomCell:
      return.zero
    }
  }
  
  func heightForText(_ text: String, width: CGFloat) -> CGFloat {
    let font = UIFont(name: "Quicksand-Regular", size: 15)
    let boundingRect = NSString(string: text)
      .boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: [NSAttributedString.Key.font: font as Any],
                    context: nil)
    return ceil(boundingRect.height)
  }
}
