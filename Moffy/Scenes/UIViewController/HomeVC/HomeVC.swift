//
//  HomeVC.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

enum HomeCellType {
    case headerCell
    case bodyCell
    case bottomCell
}

class HomeVC: BaseViewController {
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var sections: [HomeCellType] = [.headerCell, .bodyCell, .bottomCell]
    
    override func setProperties() {
        self.collectionView.registerNib(ofType: HeaderHomeCVC.self)
        self.collectionView.registerNib(ofType: BodyHomeCVC.self)
        self.collectionView.registerNib(ofType: BottomHomeCVC.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func binding() {
        PlanManager.shared.$planForWeekend
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self else {
                    return
                }
                
                self.collectionView.reloadData()
            }
            .store(in: &subscriptions)
        
        PlanManager.shared.$yourPlan
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self else {
                    return
                }
                
                self.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    @IBAction func didTapSettingButton(_ sender: Any) {
        let searchVC = SearchCV()
        searchVC.hidesBottomBarWhenPushed = false
        self.push(to: searchVC, animated: true)
    }
}

extension HomeVC: UICollectionViewDelegate {
    
}

extension HomeVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.sections[section] {
        case .headerCell:
            return 1
        case .bodyCell:
            return 1
        case .bottomCell:
            return PlanManager.shared.yourPlan.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .headerCell:
            let cell = collectionView.dequeue(ofType: HeaderHomeCVC.self, indexPath: indexPath)
            return cell
        case .bodyCell:
            let cell = collectionView.dequeue(ofType: BodyHomeCVC.self, indexPath: indexPath)
            return cell
        case .bottomCell:
            let cell = collectionView.dequeue(ofType: BottomHomeCVC.self, indexPath: indexPath)
            let plan = PlanManager.shared.yourPlan[indexPath.row]
            cell.configData(with: plan)
            
            cell.movieHandler = {[weak self] plan in
                guard let self else {
                    return
                }
                
                let detailPlanVC = DetailPlanVC(with: plan)
                detailPlanVC.hidesBottomBarWhenPushed = true
                self.push(to: detailPlanVC, animated: true)
            }
            
            return cell
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .headerCell:
            return CGSize(width: collectionView.frame.width, height: 288)
        case .bodyCell:
            return CGSize(width: collectionView.frame.width, height: 26)
        case .bottomCell:
            let collectionViewWidth = collectionView.bounds.width
            let itemWidth = (collectionViewWidth - 28 * 2 - 19) / 2
            return CGSize(width: itemWidth, height: 202)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sections[section] {
        case .headerCell:
            return UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        case .bodyCell:
            return .zero
        case .bottomCell:
            return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        }
    }
}
