//
//  HomeCVC.swift
//  Moffy
//
//  Created by MRX on 21/12/2023.
//

import UIKit
import FSPagerView

class HeaderHomeCVC: BaseCollectionViewCell {
    @IBOutlet weak var suggestPlanView: FSPagerView!
    
    override func setProperties() {
        self.suggestPlanView.delegate = self
        self.suggestPlanView.dataSource = self
        let collectionViewWidth = contentView.frame.width + 26
        self.suggestPlanView.itemSize = CGSize(width: collectionViewWidth, height: 288.0)
        self.suggestPlanView.transformer = FSPagerViewTransformer(type: .linear)
        self.suggestPlanView.register(UINib(nibName: "SuggestPlanCVC", bundle: nil), forCellWithReuseIdentifier: "SuggestPlanCVC")
        self.suggestPlanView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollToSecondItem()
        }
    }
    
    func scrollToSecondItem() {
        if PlanManager.shared.planForWeekend.count > 1 {
            let indexPath = IndexPath(item: 1, section: 0)
            suggestPlanView.scrollToItem(at: indexPath.row,  animated: true)
        }
    }
}

extension HeaderHomeCVC: FSPagerViewDelegate {
    
}

extension HeaderHomeCVC: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return PlanManager.shared.planForWeekend.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = suggestPlanView.dequeueReusableCell(withReuseIdentifier: "SuggestPlanCVC", at: index) as! SuggestPlanCVC
        let plan = PlanManager.shared.planForWeekend[index]
        cell.configData(with: plan)
        cell.delegate = self
        return cell
    }
}
extension HeaderHomeCVC: SuggestPlanCVCDelegate {
    func didAddToPlan(_ plan: PlanModel) {
        PlanManager.shared.createYourPlan(plan)
    }
}
