//
//  SplashVC.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import UIKit

class SplashVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveToOnboardVC()
    }
    
    private func moveToOnboardVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let onboardVC = OnboardVC()
            self.push(to: onboardVC, animated: false)
        }
    }
}
