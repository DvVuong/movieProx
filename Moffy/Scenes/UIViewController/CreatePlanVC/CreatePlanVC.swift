//
//  CreatePlanVC.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

enum cellType {
  case headerCell
  case bodyCell
  case movieCell
  case bottomCell
}

class CreatePlanVC: BaseViewController {
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var sections: [cellType] = [.headerCell, .bodyCell, .movieCell, .bottomCell]
  private var selectedMovies: [Movie] = []
  private var movie: Movie?
  private var note: String = ""
  private var namePlan: String = ""
  private var imageCoverPlan: String = ""
  private var startDate: Date = Date()
  private var endDate: Date = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.hideKeyboardWhenTappedAround()
  }
  
  override func setProperties() {
    self.collectionView.registerNib(ofType: CreatePlanCVC.self)
    self.collectionView.registerNib(ofType: BodyCreatePlanCVC.self)
    self.collectionView.registerNib(ofType: BottomCreatePlanCVC.self)
    self.collectionView.registerNib(ofType: MoviesCVC.self)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
  }
  
  override func binding() {
    MovieManager.shared.$seclectedMovies
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        self.collectionView.reloadData()
      }
      .store(in: &subscriptions)
  }
  
  @IBAction func didTapBackButton(_ sender: Any) {
    self.pop(animated: true)
  }
}

extension CreatePlanVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  }
}

extension CreatePlanVC: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch sections[section] {
    case .headerCell:
      return 1
    case .bodyCell:
      return 1
    case .movieCell:
      return selectedMovies.count
    case .bottomCell:
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch sections[indexPath.section] {
    case .headerCell:
      let cell = collectionView.dequeue(ofType: CreatePlanCVC.self, indexPath: indexPath)
      if let movie = self.movie {
        cell.configData(with: movie)
      }
      
      cell.handler = {[weak self]  in
        guard let self else {
          return
        }
        let chooseVC = ChooseCoverVC(title: "Choose Cover", contans: 0, isShowAddButton: true)
        chooseVC.delegate = self
        self.push(to: chooseVC, animated: true)
      }
      
      return cell
    case .bodyCell:
      let cell = collectionView.dequeue(ofType: BodyCreatePlanCVC.self, indexPath: indexPath)
      cell.delegate = self
      cell.bindData(with: self.startDate, endDate: self.endDate)
      return cell
    case .bottomCell:
      let cell = collectionView.dequeue(ofType: BottomCreatePlanCVC.self, indexPath: indexPath)
      cell.delegate = self
      return cell
      
    case .movieCell:
      let cell = collectionView.dequeue(ofType: MoviesCVC.self, indexPath: indexPath)
      let movie = selectedMovies[indexPath.row]
      cell.configData(with: movie, index: indexPath.row)
      cell.delegate = self
      return cell
    }
  }
  
}

extension CreatePlanVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch sections[indexPath.section] {
    case .headerCell:
      return CGSize(width: collectionView.frame.width, height: 196)
    case .bodyCell:
      return CGSize(width: collectionView.frame.width, height: 258)
    case .bottomCell:
      return CGSize(width: collectionView.frame.width, height: 255)
    case .movieCell:
      return CGSize(width: collectionView.frame.width, height: 98)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    switch sections[section] {
    case.headerCell:
      let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
      return sectionInset
    case.bodyCell:
      let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
      return sectionInset
    case .movieCell:
      let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
      return sectionInset
      
    case.bottomCell:
      let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      return sectionInset
    }
  }
}

extension CreatePlanVC: ChooseCoverVCDelegate {
  func didChooseMovie(with movies: [Movie]) {
    self.selectedMovies = movies
    self.collectionView.reloadData()
  }
  
  func didChooseCover(with item: Movie) {
    self.movie = item
    self.imageCoverPlan = item.backdropPath ?? ""
    self.collectionView.reloadData()
  }
}

extension CreatePlanVC: BodyCreatePlanCVCDelegate {
  func textInputNamePlanCompleted(with text: String) {
    self.namePlan = text
  }
  
  func didChooseMovie() {
    let chooseMovie = ChooseCoverVC(title: "Choose Film", contans: 50, isShowAddButton: false)
    chooseMovie.isChooseMovie = true
    chooseMovie.delegate = self
    self.push(to: chooseMovie, animated: true)
  }
  
  func didChooseStartDate() {
    let caledarVC = CalendarVC()
    caledarVC.modalPresentationStyle = .overFullScreen
    caledarVC.delegate = self
    caledarVC.isSelectedStartDate = true
    self.present(to: caledarVC, animated: true)
  }
  
  func didChooseEndDate() {
    let caledarVC = CalendarVC()
    caledarVC.modalPresentationStyle = .overFullScreen
    caledarVC.delegate = self
    caledarVC.isSelectedStartDate = false
    self.present(to: caledarVC, animated: true)
  }
}

extension CreatePlanVC: MoviesCVCDelegate {
  func didRemoveMovieAtIndex(at index: Int) {
    let popupVC = PopupConfirmVC()
    popupVC.modalPresentationStyle = .overFullScreen
    popupVC.handler = {[weak self]  in
      guard let self else {
        return
      }
      
      MovieManager.shared.removeSelectedMovie(index)
      self.selectedMovies.remove(at: index)
      self.collectionView.reloadData()
    }
    self.present(to: popupVC, animated: true)
  }
}

extension CreatePlanVC: BottomCreatePlanCVCDelegate {
  func textInputCompleted(with text: String) {
    self.note = text
  }
  
  func didTapDoneButton() {
    MovieManager.shared.removeSelectedMovieAll()
    let plan = PlanModel(titlePlan: self.namePlan,
                         startDate: self.startDate,
                         endDate: self.endDate,
                         generPlan: "",
                         movie: selectedMovies,
                         imageCoverPlan: self.imageCoverPlan,
                         note: self.note )
    
    PlanManager.shared.createYourPlan(plan)
    self.pop(animated: true)
  }
}

extension CreatePlanVC: CalendarVCDelegate {
  func didChooseStartDate(with date: Date) {
    self.startDate = date
    self.collectionView.reloadData()
  }
  
  func diChooseEndDate(with date: Date) {
    self.endDate = date
    self.collectionView.reloadData()
  }
}
